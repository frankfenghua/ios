#pragma once
#include <curl/curl.h>
#include "Util.h"

#define CHAR_MEMORY

#ifndef CHAR_MEMORY
#include <string>
#endif

class CRequest
{
private:
	requestId				m_RequestId;
	const char				*m_Url;
	methodHttp				m_HttpMethod;
	const char				*m_Data;
	int						m_DataLength;
	NetworkLibraryCallback	m_Callback;
	CURL					*m_Curl;
	requestStatus			m_Status;
	curl_socket_t			m_Socket;
	void					*m_UserContext;
	struct curl_slist		*m_HeaderFields;
	bool					m_HeaderIsSet;
	bool					m_IsPostPush;
	
	
	static bool				m_CertificateIsSet;
	static const char		*m_ClientCertificatePath;
	static const char		*m_CACertificatePath;
	static const char		*m_PrivateKeyPath;

#ifdef CHAR_MEMORY
	struct MemoryStruct		m_DownloadedData;
#else
	std::string				m_DownloadedData;

	void AddDownloadedData(std::string p_Data)
	{
		m_DownloadedData += p_Data;
	}

	size_t GotContent(void *ptr,size_t size);
#endif

    static size_t GotData(void *ptr, size_t size, size_t nmemb, void *data);
    static size_t GotDataPush(void *ptr, size_t size, size_t nmemb, void *data);


public:
	
#ifdef CHAR_MEMORY
	struct MemoryStruct GetDownloadedData() { return m_DownloadedData; }
#else
	std::string GetDownloadedData() { return m_DownloadedData; }
#endif
	// status get and setters
	requestStatus GetRequestStatus()				{ return m_Status; }
	void SetRequestStatus(requestStatus p_Status)	{ m_Status = p_Status; }
	void SetStatusOpen()							{ m_Status = RSOpen; }
	void SetStatusSend()							{ m_Status = RSSend; }
	void SetStatusDone()							{ m_Status = RSDone; }
	void SetStatusReady()							
	{ 
		if(m_HeaderIsSet)
		{
			//curl_easy_setopt(m_Curl, CURLOPT_HEADER, 1L); TODO: check if that must be added
			curl_easy_setopt(m_Curl, CURLOPT_HTTPHEADER, m_HeaderFields);

			//TODO: some error handle??
		}
		m_Status = RSReady; 
	}
	void SetStatusCancel()							{ m_Status = RSCancel; }
	void SetStatusWorking()							{ m_Status = RSWorking; }
	void SetStatusWaitingForDone()					{ m_Status = RSWaitingForDone; }


	// get/set socket
	void SetSocket(long p_Socket)					{ m_Socket = p_Socket; }
	curl_socket_t GetSocket()						{ return m_Socket; }

	CURL* GetCurl()									{ return m_Curl; }
	requestId GetRequestId()						{ return m_RequestId; }
	methodHttp GetMethodHttp()						{ return m_HttpMethod; }

	void SetDataToSend(const char *p_Data, int p_DataLength)
	{
		m_Data = p_Data;
		m_DataLength = p_DataLength;
	}

	int GetDataLength()								{ return m_DataLength; }
	const char* GetData()							{ return m_Data; }

	// get/set for callback function
	NetworkLibraryCallback GetCallbackFunction()	{ return m_Callback; }
	void SetCallbackFunction(NetworkLibraryCallback p_Callback) { m_Callback = p_Callback; }

	//get/set for UserContext
	void* GetUserContext()	{ return m_UserContext; }
	void SetUserContext(void *p_UserContext) { m_UserContext = p_UserContext; }

	bool GetIsPostPush() { return m_IsPostPush; }

	void SetTimeout(int p_Timeout);
	void SetUserAgent(const char *p_UserAgent);
	void SetHeaderField(const char *p_FieldName, const char *p_FieldData);

	void SetDownloadedDataBySocket(const char * p_DownloadedData, int p_DownloadedDataLength);

	int WaitOnSocket(curl_socket_t p_Socket, int p_Receiving, long p_TimeoutMs);

	// functions setting after request finish
	void SetError(errorCode p_ErrorCode, CURLcode p_Code, const char *p_Msg);
	void SetSuccessError(errorCode p_ErrorCode);
	void SetSuccess();

	void SendErrorByCallback(errorCode p_ErrorCode, int p_cUrlCode = NULL);
	void SendResultByCallback();

	CRequest(requestId p_RequestId, const char *p_Url, methodHttp p_HttpMethod, const char *p_Data, int p_DataLength, NetworkLibraryCallback p_Callback);
	~CRequest(void);


	static void SetCertificatesPaths(const char *p_CACertificatePath)
	{
		m_CACertificatePath = p_CACertificatePath;
		m_CertificateIsSet = true;
	}

	//char* Error;
};