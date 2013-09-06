#pragma once

#include "Util.h"

#ifdef __cplusplus
extern "C"
{
#endif

errorCode InitializeNetworkSystem();

errorCode DestroyNetworkSystem();

requestId CreateGetRequest(const char *p_Url);

requestId CreatePostRequest(const char *p_Url, const char *p_PostData, int p_Bytes);
    
requestId CreatePostRequestPush(const char *p_Url, const char *p_PostData, int p_Bytes);

requestId CreateSocketRequest(const char *p_Url, const char *p_SendData, int p_Bytes);

errorCode StartConnection(requestId p_IdRequest);

errorCode CancelConnection(requestId p_IdRequest);

errorCode RegisterCallback(requestId p_IdRequest, NetworkLibraryCallback p_Callback, void *p_UserContext);

errorCode SendThroughSocket(requestId p_IdRequest, const char *p_Data, int p_Bytes);

errorCode SetTimeout(requestId p_IdRequest, int p_Timeout);

errorCode SetUserAgent(requestId p_IdRequest, const char *p_UserAgent);

errorCode SetHeaderField(requestId p_IdRequest, const char *p_FieldName, const char *p_FieldData);

errorCode SetCertificatePath(const char *p_CACertificatePath);

errorCode RegisterReachabilityFunction(ReachabilityCallback p_Callback);
    
#ifdef __cplusplus
}

#endif
