// Generated Code - DO NOT EDIT !!
// generated by 'emugen'


#include <string.h>
#include "foo_server_context.h"


#include <stdio.h>

int foo_server_context_t::initDispatchByName(void *(*getProc)(const char *, void *userData), void *userData)
{
	fooAlphaFunc = (fooAlphaFunc_server_proc_t) getProc("fooAlphaFunc", userData);
	fooIsBuffer = (fooIsBuffer_server_proc_t) getProc("fooIsBuffer", userData);
	fooUnsupported = (fooUnsupported_server_proc_t) getProc("fooUnsupported", userData);
	return 0;
}
