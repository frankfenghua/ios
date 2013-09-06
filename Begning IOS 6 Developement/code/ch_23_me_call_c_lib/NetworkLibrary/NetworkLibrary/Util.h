#pragma once

typedef int requestId;

typedef enum ErrorCodes
{
	ErrorOk = 0,
	ErrorUndefine,
	ErrorRequestNotExist,
	ErrorRequestCannotBeCanceled,
	ErrorUndefineResultDone,
	ErrorThreadNotCreated,
	ErrorNetworkSystemAlreadyExist,
	ErrorNetworkSystemNotExist,
	ErrorMultiAddHandleProblem,
	ErrorRequestSocketIsNotOpen,
	ErrorSocketWarningNotAllSend,
	ErrorSocketTimeout,
	ErrorSocketGetInfo,
	ErrorSocketPerform,
	ErrorNotEnoughMemoryToAllocResponeGetOrPost,
	ErrorNotEnoughMemoryToAllocResponeSocket,
	ErrorRequestWasAlreadyStarted,
	ErrorCanNotChangeRequestAlreadyStarted,
	ErrorConnectionEndedByServer,
} errorCode;

typedef enum MethodHttp
{
	MethodGet = 0,
	MethodPost,
	MethodSocket,
    MethodPostPush
} methodHttp;

typedef enum RequestStatus
{
	RSNone = 0,
	RSCreated,
	RSReady,
	RSOpen,
	RSSend,
	RSCancel,
	RSWorking,
	RSWaitingForDone,
	RSDone
} requestStatus;


struct MemoryStruct 
{
	char *memory;
	size_t size;
};

typedef int(*NetworkLibraryCallback)(requestId p_Request, char *p_Data, int p_Bytes, errorCode p_Code, void *p_UserContext);
typedef bool(*ReachabilityCallback)();
