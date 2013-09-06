#include "memory.h"
#include "stdlib.h"
#include "Request.h"
#include <string.h>

bool CRequest::m_CertificateIsSet = false;
const char *CRequest::m_CACertificatePath = NULL;

CRequest::CRequest(requestId p_RequestId, const char *p_Url, methodHttp p_HttpMethod, const char *p_Data, int p_DataLength, NetworkLibraryCallback p_Callback)
{
	m_RequestId = p_RequestId;
	m_Url = p_Url;
	m_HttpMethod = p_HttpMethod;
	m_Data = p_Data;
	m_DataLength = p_DataLength;
	m_Callback = p_Callback;
	m_Status = RSCreated;//RSReady;		// TODO: change to RSCreated when function start and cancel will start work

	m_HeaderFields = NULL;
	m_HeaderIsSet = false;

	m_IsPostPush = false;
	
	//Error = (char*)malloc(1024);
	//memset(Error, 0, 1024); 
	
	m_DownloadedData.memory = (char*) malloc(1);  // will be grown as needed by the realloc
	m_DownloadedData.memory[0] = '\0';
	m_DownloadedData.size = 0;   // no data at this point
	
	m_Curl = curl_easy_init();	// TODO: error handle
	if (m_Curl == NULL)
	{
		printf("Something wrong with init in Request constructor.\n");
		//// what after error????????
	}
	

	//settings depended of HttpMehod. For now only GET setting there should be depend method
	
	curl_easy_setopt(m_Curl, CURLOPT_URL, m_Url);
	
	if(m_CertificateIsSet)
	{
		curl_easy_setopt(m_Curl, CURLOPT_SSL_VERIFYHOST, 2L);
		// set the file with the certs vaildating the server

		// cert is stored PEM coded in file...  
		// since PEM is default, we needn't set it for PEM 
		curl_easy_setopt(m_Curl,CURLOPT_SSLCERTTYPE, "PEM");  
		curl_easy_setopt(m_Curl,CURLOPT_CAINFO, m_CACertificatePath);

		curl_easy_setopt(m_Curl, CURLOPT_SSL_VERIFYPEER, 1L);
	}
	else
	{
		curl_easy_setopt(m_Curl, CURLOPT_SSL_VERIFYPEER, 0L);
		curl_easy_setopt(m_Curl, CURLOPT_SSL_VERIFYHOST, 0L);
	}

	if (m_HttpMethod == MethodGet)
	{
		curl_easy_setopt(m_Curl, CURLOPT_WRITEFUNCTION, CRequest::GotData);
		curl_easy_setopt(m_Curl, CURLOPT_WRITEDATA, (void *)this);
		//curl_easy_setopt (m_Curl, CURLOPT_ERRORBUFFER, Error );
	}

	if (m_HttpMethod == MethodPost)
	{
		curl_easy_setopt(m_Curl, CURLOPT_POSTFIELDS, p_Data);
        curl_easy_setopt(m_Curl, CURLOPT_POSTFIELDSIZE, p_DataLength);
        curl_easy_setopt(m_Curl, CURLOPT_POST, 1L);
		curl_easy_setopt(m_Curl, CURLOPT_WRITEFUNCTION, CRequest::GotData);
		curl_easy_setopt(m_Curl, CURLOPT_WRITEDATA, (void *)this);
        curl_easy_setopt(m_Curl, CURLOPT_CONNECTTIMEOUT, 5);
        curl_easy_setopt(m_Curl, CURLOPT_TIMEOUT, 15);
	}
    
    if (m_HttpMethod == MethodPostPush)
	{
		curl_easy_setopt(m_Curl, CURLOPT_POSTFIELDS, p_Data);
        curl_easy_setopt(m_Curl, CURLOPT_POSTFIELDSIZE, p_DataLength);
        curl_easy_setopt(m_Curl, CURLOPT_POST, 1L);
		curl_easy_setopt(m_Curl, CURLOPT_WRITEFUNCTION, CRequest::GotDataPush);
		curl_easy_setopt(m_Curl, CURLOPT_WRITEDATA, (void *)this);
//		curl_easy_setopt(m_Curl, CURLOPT_VERBOSE, 1);
        curl_easy_setopt(m_Curl, CURLOPT_TCP_KEEPALIVE, 1);
        curl_easy_setopt(m_Curl, CURLOPT_TCP_KEEPINTVL, 1);
        curl_easy_setopt(m_Curl, CURLOPT_TCP_KEEPIDLE, 1);
        curl_easy_setopt(m_Curl, CURLOPT_FRESH_CONNECT, 1);        
        curl_easy_setopt(m_Curl, CURLOPT_CONNECTTIMEOUT, 5);
		m_IsPostPush = true;
//        m_HttpMethod = MethodPost;
	}

    
	if (m_HttpMethod == MethodSocket)
	{
		curl_easy_setopt(m_Curl, CURLOPT_CONNECT_ONLY, 1L);	
	}
}

CRequest::~CRequest(void)
{
//    printf("destroy request with id %i\n", m_RequestId);

	if(m_HeaderIsSet)
	{
		curl_slist_free_all(m_HeaderFields);
	}
	curl_easy_cleanup(m_Curl);	
#ifdef CHAR_MEMORY
	free(m_DownloadedData.memory);
#endif
}

#ifdef CHAR_MEMORY
size_t CRequest::GotData(void *ptr, size_t size, size_t nmemb, void *data)
{
  size_t realsize = size * nmemb;
  struct MemoryStruct *mem = &((CRequest *)data)->m_DownloadedData;
 
  mem->memory = (char*) realloc(mem->memory, mem->size + realsize + 1);
  if (mem->memory == NULL) 
  {
    // out of memory!
    printf("Error: Not enough memory (realloc returned NULL)\n");
	((CRequest *)data)->SendErrorByCallback(ErrorNotEnoughMemoryToAllocResponeGetOrPost);
	return mem->size; // ??
  }
 
  memcpy(&(mem->memory[mem->size]), ptr, realsize);
  mem->size += realsize;
  mem->memory[mem->size] = 0;
 
  return realsize;
}
#else
size_t CRequest::GotData(void *ptr, size_t size, size_t nmemb, void *data)
{
	  size_t realsize = size * nmemb;
	  CRequest *mem = (CRequest *)data;
	  return mem->GotContent(ptr,realsize);
}

size_t CRequest::GotContent(void *ptr,size_t size) 
{
	AddDownloadedData(std::string((char *)ptr,size));
	return size;
}
#endif

size_t CRequest::GotDataPush(void *ptr, size_t size, size_t nmemb, void *data)
{   
    size_t realsize = size * nmemb;
    
    CRequest *request = (CRequest *)data;
    
    struct MemoryStruct *mem = &((CRequest *)data)->m_DownloadedData;
    
    mem->memory = (char*) realloc(mem->memory, mem->size + realsize + 1);
    if (mem->memory == NULL)
    {
        // out of memory!
        printf("Error: Not enough memory (realloc returned NULL)\n");
        ((CRequest *)data)->SendErrorByCallback(ErrorNotEnoughMemoryToAllocResponeGetOrPost);
        return mem->size; // ??
    }
    
    memcpy(&(mem->memory[mem->size]), ptr, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = 0;
    
    request->SendResultByCallback();
    mem->size = 0;
    //    m_Callback(m_RequestId, m_DownloadedData.memory, m_DownloadedData.size, ErrorOk, m_UserContext);
    //    SendResultByCallback();
    
    
    
    return realsize;
}



void CRequest::SetError(errorCode p_ErrorCode, CURLcode p_Code, const char *p_Msg) 
{
	//curl_easy_cleanup(m_Curl);
	//m_Curl = 0;
	printf("SetError: %s\n", p_Msg);
	SendErrorByCallback(p_ErrorCode, p_Code);
}

void CRequest::SetSuccessError(errorCode p_ErrorCode) 
{
//	printf("SetSuccessError: %i\n", p_ErrorCode);
   	printf("fhua SetSuccessError: %i\n", p_ErrorCode);
	SendErrorByCallback(p_ErrorCode);
}

void CRequest::SetSuccess() 
{
	//curl_easy_cleanup(m_Curl);
	//m_Curl = 0;
	SendResultByCallback();

	/////////////////////////DEV ONLY/////////////////////////
	//char *tmpResult = new char [foundRequest->GetDownloadedData().size()+1];
	//strcpy(tmpResult, foundRequest->GetDownloadedData().c_str());
	//printf("%s", GetDownloadedData());
	//delete[] tmpResult;
	/////////////////////////DEV ONLY/////////////////////////
}


int CRequest::WaitOnSocket(curl_socket_t p_Socket, int p_Receiving, long p_TimeoutMs)
{
  struct timeval tv;
  fd_set infd, outfd, errfd;
  int res;
 
  tv.tv_sec = p_TimeoutMs / 1000;
  tv.tv_usec= (p_TimeoutMs % 1000) * 1000;
 
  FD_ZERO(&infd);
  FD_ZERO(&outfd);
  FD_ZERO(&errfd);
 
  FD_SET(p_Socket, &errfd); /* always check for error */ 
 
  if (p_Receiving)
  {
    FD_SET(p_Socket, &infd);
  }
  else
  {
    FD_SET(p_Socket, &outfd);
  }
 
  /* select() returns the number of signalled sockets or -1 */ 
  res = select(p_Socket + 1, &infd, &outfd, &errfd, &tv);
  return res;
}

void CRequest::SendErrorByCallback(errorCode p_ErrorCode, int p_cUrlCode)
{
	if (m_Callback == NULL)
		return;
	m_Callback(m_RequestId, NULL, p_cUrlCode, p_ErrorCode, m_UserContext);
//    m_Callback = NULL;
}

void CRequest::SendResultByCallback()
{
	if (m_Callback == NULL)
		return;
	m_Callback(m_RequestId, m_DownloadedData.memory, m_DownloadedData.size, ErrorOk, m_UserContext);

}

void CRequest::SetDownloadedDataBySocket(const char * p_DownloadedData, int p_DownloadedDataLength)
{
	free(m_DownloadedData.memory);
 
	m_DownloadedData.memory = (char*) malloc(p_DownloadedDataLength);
	if (m_DownloadedData.memory == NULL) 
	{
		// out of memory!
		printf("Error: Not enough memory (malloc returned NULL)\n");
		SendErrorByCallback(ErrorNotEnoughMemoryToAllocResponeSocket);
		return ; // ??
	}
 
	memcpy(m_DownloadedData.memory, p_DownloadedData, p_DownloadedDataLength);
	m_DownloadedData.size = p_DownloadedDataLength;
 
  return ;
}

void CRequest::SetTimeout(int p_Timeout)
{
	curl_easy_setopt(m_Curl, CURLOPT_TIMEOUT, p_Timeout);
}

void CRequest::SetUserAgent(const char *p_UserAgent)
{
	curl_easy_setopt(m_Curl, CURLOPT_USERAGENT, p_UserAgent);
}

void CRequest::SetHeaderField(const char *p_FieldName, const char *p_FieldData)
{
	char *tmp = (char*) malloc( (strlen(p_FieldName) + strlen(p_FieldData) + 3) );
	strcpy (tmp, p_FieldName);
	strcat (tmp,": ");
	strcat (tmp, p_FieldData);
	m_HeaderIsSet = true;
	m_HeaderFields = curl_slist_append(m_HeaderFields, tmp);
	free(tmp);
}