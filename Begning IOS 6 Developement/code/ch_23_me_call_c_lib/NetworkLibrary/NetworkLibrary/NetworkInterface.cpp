// standard includes
#include <curl/curl.h>
#include <map>
#include <list>
#include <queue>
#include <pthread.h> 

// project includes
#include "Util.h"
#include "NetworkInterface.h"
#include "Request.h"

void SocketManageFunction();
void GetPostManageFunction();
void *MainThreadFunction(void * arg);
void CleanupNetworkSystem();
void IncrementRequestCount(methodHttp p_Method);
void DecrementRequestCount(methodHttp p_Method);
bool CheckReachability();
errorCode RegisterCallback(requestId p_IdRequest, NetworkLibraryCallback p_Callback);

// maximum of running requests
#define		MAX_GET_REQUESTS 3
#define		MAX_POST_REQUESTS 6
#define		MAX_SOCKET_REQUESTS 5

// actual count of working Request by type
int			g_actualGetRequestsCount;
int			g_actualPostRequestsCount;
int			g_actualSocketRequestsCount;

// handle to thread and blockade to only one thread, variable to shutdown thread
pthread_t	g_mainThread;
bool		g_mainThreadExist = false;
bool		g_mainThreadWorking = false;

// lists of requests, map to faster use and IdPool for requests
std::map<CURL *,CRequest *> requestMap;
std::list<CRequest*>		requestQueue;
std::list<CRequest*>		requestSocketQueue;
unsigned int				requestIdPool; // 0 - reserved, start from 1

// curl variables
CURLM*						curlMulti;
int							curlHandleCount;
ReachabilityCallback		g_ReachabilityFunc = NULL;

struct InfoResultStruct 
{
	CURL *handle;
	CURLcode result;
};

void SocketManageFunction()
{
	std::list<CRequest *>::iterator eSocket = requestSocketQueue.end();
	std::list<CRequest *>::iterator iSocket = requestSocketQueue.begin();

	for ( ; iSocket != eSocket; iSocket++ )
	{
		// remove canceled request
		if ( iSocket != eSocket && (*iSocket)->GetRequestStatus() == RSCancel )
		{
			DecrementRequestCount((*iSocket)->GetMethodHttp());
			CRequest *toRemove = (*iSocket);
			iSocket = requestSocketQueue.erase(iSocket);
            delete toRemove;
			if (iSocket == eSocket) break;
		}

		if ( ( (*iSocket)->GetRequestStatus() == RSSend || 
				(*iSocket)->GetRequestStatus() == RSReady ||
				(*iSocket)->GetRequestStatus() == RSOpen) && 
				(*iSocket)->GetMethodHttp() == MethodSocket )
		{
			CURLcode code;
			size_t iolen;
			long socketExtract;
			bool shouldBeHandled = true;

			if ( (*iSocket)->GetRequestStatus() == RSReady)
			{
					
				if (g_actualSocketRequestsCount >= MAX_SOCKET_REQUESTS)
				{
					shouldBeHandled = false;
				}
				if (shouldBeHandled)
				{
					code = curl_easy_perform((*iSocket)->GetCurl());
 
					if (code != CURLE_OK)
					{
						printf("Error: Socket Perform : %s\n", curl_easy_strerror(code));
						(*iSocket)->SendErrorByCallback(ErrorSocketPerform, code);
						continue; 
					}
					IncrementRequestCount((*iSocket)->GetMethodHttp());
					(*iSocket)->SetStatusSend();	// hould be RSOpen or RSSend?????????
				}
					
			}
			if (shouldBeHandled)
			{
				code = curl_easy_getinfo( (*iSocket)->GetCurl(), CURLINFO_LASTSOCKET, &socketExtract);
				
				if (code != CURLE_OK)
				{
					printf("Error: %ld\n", socketExtract);
					printf("Error: %s\n", curl_easy_strerror(code));
					(*iSocket)->SendErrorByCallback(ErrorSocketGetInfo, code);
					continue;
				}
				if ( (*iSocket)->GetRequestStatus() == RSSend )
				{

					(*iSocket)->SetSocket(socketExtract);
					
					if ( !(*iSocket)->WaitOnSocket( (*iSocket)->GetSocket(), 0, 0L) )
					{
						printf("Error: Socket timeout.\n");
						(*iSocket)->SendErrorByCallback(ErrorSocketTimeout);
						continue;
					}

					code = curl_easy_send( (*iSocket)->GetCurl(), (*iSocket)->GetData(), (*iSocket)->GetDataLength(), &iolen);

					if ( (*iSocket)->GetDataLength() > iolen)
					{
						printf("Warning: Not all sended in easy_send for socket.\n");
						(*iSocket)->SendErrorByCallback(ErrorSocketWarningNotAllSend, code);
					}
					(*iSocket)->SetStatusOpen();
				}
				
				char buf[1024];
				
				(*iSocket)->WaitOnSocket( (*iSocket)->GetSocket(), 1, 0L);
				code = curl_easy_recv( (*iSocket)->GetCurl(), buf, 1024, &iolen);
 
				if (code == CURLE_AGAIN)
				{
					//printf("No data on socket.");

					// One of possible solutions is to call curl_easy_recv in loop and
					// resize buf if iolen == buf length till socket is empty and then 
					// send buf with all data
				}

				if (code == CURLE_OK)
				{
					curl_off_t nread;
					nread = (curl_off_t)iolen;

					(*iSocket)->SetDownloadedDataBySocket(buf, nread);
					(*iSocket)->SetSuccess();
					//printf("Received %" CURL_FORMAT_CURL_OFF_T " bytes.\n", nread);

					// send to callback this data 
				}
			}
		}
	}
}

void GetPostManageFunction()
{
	// GET / POST requests code
	curlHandleCount = 0;
	CURLMcode code = CURLM_CALL_MULTI_PERFORM;
	while (code == CURLM_CALL_MULTI_PERFORM)
	{
		code = curl_multi_perform(curlMulti, &curlHandleCount);
		/////////////////////////DEV ONLY/////////////////////////
		//if (code !=0)
		//{
		//	//requestQueue.front()->Error[1023] = '\0';
		//	printf("Perform: %d %d!!!\n", code, curlHandleCount);
		//	//printf("%s\n", requestQueue.front()->Error);
		//}
		//if (curlHandleCount !=0)
		//{
		//	requestQueue.front()->Error[1023] = '\0';
		//	printf("Perform: %d %d!!!\n", code, curlHandleCount);
		//	printf("%s\n", requestQueue.front()->Error);
		//}
		/////////////////////////DEV ONLY/////////////////////////
	}
	if ( code != CURLM_OK && curlHandleCount != 0) 
	{
		printf("Error: Something happend in perform GET/POST: %d!!!\n", code);
		//// what after error????????
	}

	CURLMsg *msg; // for picking up messages with the transfer status 
	int msgsLeft; // how many messages are left 

	std::list<InfoResultStruct> handlesInfoResult;
	while ( (msg = curl_multi_info_read(curlMulti, &msgsLeft)) ) 
	{
		if (msg->msg == CURLMSG_DONE) 
		{
			std::map<CURL *, CRequest *>::iterator f = requestMap.find(msg->easy_handle);
			f->second->SetStatusWaitingForDone();
			InfoResultStruct d = { msg->easy_handle, msg->data.result };
			handlesInfoResult.push_back(d);
		}
		if (msgsLeft == 0)
			break;
	}

	{
		std::list<InfoResultStruct>::iterator e = handlesInfoResult.end();
		std::list<InfoResultStruct>::iterator i = handlesInfoResult.begin();
		for ( ; i != e; i++ ) 
		{
			CURLcode result = i->result;
			CURL *handle = i->handle;
			std::map<CURL *, CRequest *>::iterator e = requestMap.end();
			std::map<CURL *, CRequest *>::iterator f = requestMap.find(handle);
			if ( f == e ) 
			{
				printf("REQUEST NOT FOUND FOR HANDLE %p\n", handle);
				continue;
			}

			CRequest *foundRequest = f->second;
			curl_multi_remove_handle(curlMulti, handle);
			DecrementRequestCount(foundRequest->GetMethodHttp());

			if (foundRequest->GetIsPostPush())
			{
				foundRequest->SetSuccessError(ErrorConnectionEndedByServer);
				foundRequest->SetStatusDone();
			}
			else
			{
				if ( result != CURLE_OK ) 
				{
					foundRequest->SetError(ErrorUndefineResultDone, result, curl_easy_strerror(result));
					foundRequest->SetStatusDone();
				} 
				else 
				{
					foundRequest->SetSuccess();
					foundRequest->SetStatusDone();
				}
			}
			requestMap.erase(f);
			requestQueue.remove(foundRequest);
            delete foundRequest;
		}
	}


	std::list<CRequest *>::iterator e = requestQueue.end();
	std::list<CRequest *>::iterator i = requestQueue.begin();

		// start requests which are ready GET / POST
	for ( ; i != e; i++ )
	{
			// remove canceled request
		if ( i != e && (*i)->GetRequestStatus() == RSCancel )
		{
			curl_multi_remove_handle(curlMulti, (*i)->GetCurl());
			std::map<CURL *, CRequest *>::iterator f = requestMap.find((*i)->GetCurl());
			if (f != requestMap.end())
			{
				requestMap.erase(f);
			}
			CRequest *toRemove = (*i);
			DecrementRequestCount((*i)->GetMethodHttp());
			i = requestQueue.erase(i);
            delete toRemove;
			if (i == e) break;
		}

		if ( i != e && (*i)->GetRequestStatus() == RSReady )
		{
			bool shouldBeHandled = true;

			if ( (*i)->GetMethodHttp() == MethodGet && g_actualGetRequestsCount >= MAX_GET_REQUESTS)
			{
				shouldBeHandled = false;
			}

			if ( (*i)->GetMethodHttp() == MethodPost && g_actualPostRequestsCount >= MAX_POST_REQUESTS)
			{
				shouldBeHandled = false;
			}

			if (shouldBeHandled)
			{
				CURL *handle = (*i)->GetCurl();
				CURLMcode codem;
				codem = curl_multi_add_handle(curlMulti, handle);
				
				if (codem != CURLM_OK)
				{
					printf("Error: Something wrong with adding handle\n");
					(*i)->SendErrorByCallback(ErrorMultiAddHandleProblem, codem);
					continue;
				}
					
				requestMap[handle] = *i;
				(*i)->SetStatusWorking();
				IncrementRequestCount((*i)->GetMethodHttp());
			}
		}
	}
}

errorCode InitializeNetworkSystem()
{
	if (g_mainThreadExist == true)
	{
		return ErrorNetworkSystemAlreadyExist;
	}

	g_mainThreadWorking = true;

    int ret =  pthread_create(&g_mainThread, NULL, MainThreadFunction, NULL);
    if (ret != 0) 
	{
		return ErrorThreadNotCreated;
    }
	
	curl_global_init(CURL_GLOBAL_ALL);
	curlMulti = curl_multi_init();
	curlHandleCount = 0;
	g_actualGetRequestsCount = 0;
	g_actualPostRequestsCount = 0;
	g_actualSocketRequestsCount = 0;
	requestIdPool = 1; // 0 - reserved, start from 1
	g_mainThreadExist = true;
	return ErrorOk;
}

void *MainThreadFunction(void *arg)
{
	while (g_mainThreadWorking) // infinity thread loop
	{	
		SocketManageFunction();

		GetPostManageFunction();
		
		// it is good enough???
		sched_yield();
#ifdef _WIN32
		Sleep(50);
#else
        usleep(50);
#endif
	}

	CleanupNetworkSystem();
	pthread_exit(NULL);
	return NULL;
}

errorCode DestroyNetworkSystem()
{
	if (g_mainThreadExist)
	{
		g_mainThreadWorking = false;
		return ErrorOk;
	}

	return ErrorNetworkSystemNotExist;
}

void CleanupNetworkSystem()
{
	requestMap.clear();

	std::list<CRequest *>::iterator e = requestQueue.end();
	std::list<CRequest *>::iterator i = requestQueue.begin();

	for ( ; i != e; i++ ) 
	{
		curl_multi_remove_handle(curlMulti, (*i)->GetCurl());
		DecrementRequestCount((*i)->GetMethodHttp());
        delete (*i);
	}
	requestQueue.clear();

	e = requestSocketQueue.end();
	i = requestSocketQueue.begin();
	for ( ; i != e; i++ ) 
	{
		DecrementRequestCount((*i)->GetMethodHttp());
        delete (*i);
	}
	requestSocketQueue.clear();

	//pthread_cancel(g_mainThread); // it is good? guess not. probably by kill with signal and in MainThreadFunction end curls and thread when signal. TODO : change that
	curl_multi_cleanup(curlMulti);
	curl_global_cleanup();
	g_mainThreadExist = false;
	g_mainThreadWorking = false;
}


requestId CreateGetRequest(const char *p_Url)
{
	if (g_mainThreadExist == false)
	{
		printf("Error: Network System not initialized\n");
		return 0;
	}
	if (p_Url == NULL)
	{
		printf("Error: Created GET request URL is NULL\n");
		return 0;
	}
	if (!CheckReachability())
	{
		return -3;
	}
	CRequest *request = new CRequest(requestIdPool, p_Url, MethodGet, NULL, NULL, NULL);
	requestQueue.push_back(request);
	requestIdPool++;
	return requestIdPool - 1;
}

requestId CreatePostRequest(const char *p_Url, const char *p_PostData, int p_Bytes)
{
	if (g_mainThreadExist == false)
	{
		printf("Error: Network System not initialized\n");
		return 0;
	}
	if (p_Url == NULL)
	{
		printf("Error: Created POST request URL is NULL\n");
		return 0;
	}
	if (p_Bytes == 0)
	{
		printf("Error: Created POST request Data length is 0\n");
		return 0;
	}
	if (p_PostData == NULL)
	{
		printf("Error: Created POST request Data is NULL\n");
		return 0;
	}
	if (!CheckReachability())
	{
		return -3;
	}

	CRequest *request = new CRequest(requestIdPool, p_Url, MethodPost, p_PostData, p_Bytes, NULL);
	requestQueue.push_back(request);
	requestIdPool++;
	return requestIdPool - 1;
}

requestId CreatePostRequestPush(const char *p_Url, const char *p_PostData, int p_Bytes)
{
	if (g_mainThreadExist == false)
	{
		printf("Error: Network System not initialized\n");
		return 0;
	}
	if (p_Url == NULL)
	{
		printf("Error: Created POST request URL is NULL\n");
		return 0;
	}
	if (p_Bytes == 0)
	{
		printf("Error: Created POST request Data length is 0\n");
		return 0;
	}
	if (p_PostData == NULL)
	{
		printf("Error: Created POST request Data is NULL\n");
		return 0;
	}
	if (!CheckReachability())
	{
		return -3;
	}
    
	CRequest *request = new CRequest(requestIdPool, p_Url, MethodPostPush, p_PostData, p_Bytes, NULL);
	requestQueue.push_back(request);
	requestIdPool++;
	return requestIdPool - 1;
}


requestId CreateSocketRequest(const char *p_Url, const char *p_SendData, int p_Bytes)
{
	if (g_mainThreadExist == false)
	{
		printf("Error: Network System not initialized\n");
		return 0;
	}
	if (p_Url == NULL)
	{
		printf("Error: Created Socket request URL is NULL\n");
		return 0;
	}
	if (p_Bytes == 0)
	{
		printf("Error: Created Socket request Data length is 0\n");
		return 0;
	}
	if (p_SendData == NULL)
	{
		printf("Error: Created Socket request Data is NULL\n");
		return 0;
	}
	if (!CheckReachability())
	{
		return -3;
	}

	CRequest *request = new CRequest(requestIdPool, p_Url, MethodSocket, p_SendData, p_Bytes, NULL);
	requestSocketQueue.push_back(request);
	requestIdPool++;
	return requestIdPool - 1;
}

errorCode StartConnection(requestId p_IdRequest)
{
	if (g_mainThreadExist == false)
	{
		return ErrorNetworkSystemNotExist;
	}

	// GET / POST
	std::list<CRequest *>::iterator e = requestQueue.end();
	std::list<CRequest *>::iterator i = requestQueue.begin();
	for ( ; i != e; i++ )
	{
		if ( (*i)->GetRequestId() == p_IdRequest)
		{
			if((*i)->GetRequestStatus() != RSCreated)
			{
				return ErrorRequestWasAlreadyStarted;
			}
			(*i)->SetStatusReady();
			return ErrorOk;
		}
	}

	// SOCKET
	std::list<CRequest *>::iterator eS = requestSocketQueue.end();
	std::list<CRequest *>::iterator iS = requestSocketQueue.begin();
	for ( ; iS != eS; iS++ )
	{
		if ( (*iS)->GetRequestId() == p_IdRequest)
		{
			if((*iS)->GetRequestStatus() != RSCreated)
			{
				return ErrorRequestWasAlreadyStarted;
			}
			(*iS)->SetStatusReady();
			return ErrorOk;
		}
	}

	return ErrorRequestNotExist;
}

errorCode CancelConnection(requestId p_IdRequest)
{
	if (g_mainThreadExist == false)
	{
		return ErrorNetworkSystemNotExist;
	}

	// GET / POST
	std::list<CRequest *>::iterator e = requestQueue.end();
	std::list<CRequest *>::iterator i = requestQueue.begin();
	for ( ; i != e; i++ )
	{
		if ( (*i)->GetRequestId() == p_IdRequest)
		{
			if ( (*i)->GetRequestStatus() == RSWorking 
				|| (*i)->GetRequestStatus() == RSReady 
				|| (*i)->GetRequestStatus() == RSCreated )
			{
				(*i)->SetStatusCancel();
				return ErrorOk;
			}
			else
				return ErrorRequestCannotBeCanceled; 
		}
	}

	// SOCKET
	std::list<CRequest *>::iterator eS = requestSocketQueue.end();
	std::list<CRequest *>::iterator iS = requestSocketQueue.begin();
	for ( ; iS != eS; iS++ )
	{
		if ( (*iS)->GetRequestId() == p_IdRequest)
		{
			(*iS)->SetStatusCancel();
			return ErrorOk;
		}
	}

	return ErrorRequestNotExist;
}

errorCode RegisterCallback(requestId p_IdRequest, NetworkLibraryCallback p_Callback, void *p_UserContext)
{
	if (g_mainThreadExist == false)
	{
		return ErrorNetworkSystemNotExist;
	}

	// GET / POST
	std::list<CRequest *>::iterator e = requestQueue.end();
	std::list<CRequest *>::iterator i = requestQueue.begin();
	for ( ; i != e; i++ )
	{
		if ( (*i)->GetRequestId() == p_IdRequest)
		{
			(*i)->SetCallbackFunction(p_Callback);
			(*i)->SetUserContext(p_UserContext);
			return ErrorOk;
		}
	}

	// SOCKET
	std::list<CRequest *>::iterator eS = requestSocketQueue.end();
	std::list<CRequest *>::iterator iS = requestSocketQueue.begin();
	for ( ; iS != eS; iS++ )
	{
		if ( (*iS)->GetRequestId() == p_IdRequest)
		{
			(*iS)->SetCallbackFunction(p_Callback);
			(*iS)->SetUserContext(p_UserContext);
			return ErrorOk;
		}
	}

	return ErrorRequestNotExist;
}

errorCode SendThroughSocket(requestId p_IdRequest, const char *p_Data, int p_Bytes)
{
	if (g_mainThreadExist == false)
	{
		return ErrorNetworkSystemNotExist;
	}

	std::list<CRequest *>::iterator e = requestSocketQueue.end();
	std::list<CRequest *>::iterator i = requestSocketQueue.begin();
	for ( ; i != e; i++ )
	{
		if ( (*i)->GetRequestId() == p_IdRequest)
		{
			if ( (*i)->GetRequestStatus() == RSOpen)
			{
				(*i)->SetDataToSend(p_Data, p_Bytes);
				(*i)->SetStatusSend();
				return ErrorOk;
			}
			else
			{
				return ErrorRequestSocketIsNotOpen;
			}
		}
	}
	return ErrorRequestNotExist;
}

void IncrementRequestCount(methodHttp p_Method)
{
	if (p_Method == MethodGet)
	{
		g_actualGetRequestsCount++;
	}
	if (p_Method == MethodPost)
	{
		g_actualPostRequestsCount++;
	}
	if (p_Method == MethodSocket)
	{
		g_actualSocketRequestsCount++;
	}
}

void DecrementRequestCount(methodHttp p_Method)
{
	if (p_Method == MethodGet)
	{
		g_actualGetRequestsCount--;
	}
	if (p_Method == MethodPost)
	{
		g_actualPostRequestsCount--;
	}
	if (p_Method == MethodSocket)
	{
		g_actualSocketRequestsCount--;
	}
}



errorCode SetTimeout(requestId p_IdRequest, int p_Timeout)
{
	if (g_mainThreadExist == false)
	{
		return ErrorNetworkSystemNotExist;
	}

	// GET / POST
	std::list<CRequest *>::iterator e = requestQueue.end();
	std::list<CRequest *>::iterator i = requestQueue.begin();
	for ( ; i != e; i++ )
	{
		if ( (*i)->GetRequestId() == p_IdRequest)
		{
			if((*i)->GetRequestStatus() != RSCreated)
			{
				return ErrorCanNotChangeRequestAlreadyStarted;
			}
			(*i)->SetTimeout(p_Timeout);
			return ErrorOk;
		}
	}
	return ErrorRequestNotExist;
}

errorCode SetUserAgent(requestId p_IdRequest, const char *p_UserAgent)
{
	if (g_mainThreadExist == false)
	{
		return ErrorNetworkSystemNotExist;
	}

	// GET / POST
	std::list<CRequest *>::iterator e = requestQueue.end();
	std::list<CRequest *>::iterator i = requestQueue.begin();
	for ( ; i != e; i++ )
	{
		if ( (*i)->GetRequestId() == p_IdRequest)
		{
			if((*i)->GetRequestStatus() != RSCreated)
			{
				return ErrorCanNotChangeRequestAlreadyStarted;
			}
			(*i)->SetUserAgent(p_UserAgent);
			return ErrorOk;
		}
	}
	return ErrorRequestNotExist;
}

errorCode SetHeaderField(requestId p_IdRequest, const char *p_FieldName, const char *p_FieldData)
{
	if (g_mainThreadExist == false)
	{
		return ErrorNetworkSystemNotExist;
	}

	// GET / POST
	std::list<CRequest *>::iterator e = requestQueue.end();
	std::list<CRequest *>::iterator i = requestQueue.begin();
	for ( ; i != e; i++ )
	{
		if ( (*i)->GetRequestId() == p_IdRequest)
		{
			if((*i)->GetRequestStatus() != RSCreated)
			{
				return ErrorCanNotChangeRequestAlreadyStarted;
			}
			(*i)->SetHeaderField(p_FieldName, p_FieldData);
			return ErrorOk;
		}
	}
	return ErrorRequestNotExist;
}

errorCode SetCertificatePath(const char *p_CACertificatePath)
{
	CRequest::SetCertificatesPaths(p_CACertificatePath);
	return ErrorOk;
}

errorCode RegisterReachabilityFunction(ReachabilityCallback p_Callback)
{
	g_ReachabilityFunc = p_Callback;
	return ErrorOk;
}

bool CheckReachability()
{
	if (g_ReachabilityFunc != NULL)
	{
		bool result = g_ReachabilityFunc();
		return result;
	}
	else
	{
		//CURL *curl;
		//CURLcode res;
 		//
		//curl = curl_easy_init();
		//if(curl) 
		//{
		//	curl_easy_setopt(curl, CURLOPT_URL, "www.google.com");
		//	while ((res = curl_easy_perform(curl)) != CURLE_OK)
		//	{
		//		switch (res)
		//		{
		//			case CURLE_COULDNT_CONNECT:
		//			case CURLE_COULDNT_RESOLVE_HOST:
		//			case CURLE_COULDNT_RESOLVE_PROXY:
		//				return false;
		//				break;
		//			default:
		//				return false;
		//				//cerr<<"Request failed:"<<curl_easy_strerror(res)<<endl;
		//				//exit(1);
		//		}
		//	} 
 		//
		//	/* always cleanup */ 
		//	curl_easy_cleanup(curl);
		//	return true;
		//}
		return true;
	}
}