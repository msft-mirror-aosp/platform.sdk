// Generated Code - DO NOT EDIT !!
// generated by 'emugen'


#include <string.h>
#include "foo_opcodes.h"

#include "foo_enc.h"


#include <stdio.h>
static void enc_unsupported()
{
	ALOGE("Function is unsupported\n");
}

void fooAlphaFunc_enc(void *self , FooInt func, FooFloat ref)
{

	foo_encoder_context_t *ctx = (foo_encoder_context_t *)self;
	IOStream *stream = ctx->m_stream;

	 unsigned char *ptr;
	 const size_t packetSize = 8 + 4 + 4;
	ptr = stream->alloc(packetSize);
	int tmp = OP_fooAlphaFunc;memcpy(ptr, &tmp, 4); ptr += 4;
	memcpy(ptr, &packetSize, 4);  ptr += 4;

		memcpy(ptr, &func, 4); ptr += 4;
		memcpy(ptr, &ref, 4); ptr += 4;
}

FooBoolean fooIsBuffer_enc(void *self , void* stuff)
{

	foo_encoder_context_t *ctx = (foo_encoder_context_t *)self;
	IOStream *stream = ctx->m_stream;

	const unsigned int __size_stuff =  (4 * sizeof(float));
	 unsigned char *ptr;
	 const size_t packetSize = 8 + __size_stuff + 1*4;
	ptr = stream->alloc(packetSize);
	int tmp = OP_fooIsBuffer;memcpy(ptr, &tmp, 4); ptr += 4;
	memcpy(ptr, &packetSize, 4);  ptr += 4;

	*(unsigned int *)(ptr) = __size_stuff; ptr += 4;
	memcpy(ptr, stuff, __size_stuff);ptr += __size_stuff;

	FooBoolean retval;
	stream->readback(&retval, 1);
	return retval;
}

foo_encoder_context_t::foo_encoder_context_t(IOStream *stream)
{
	m_stream = stream;

	fooAlphaFunc = (fooAlphaFunc_enc);
	fooIsBuffer = (fooIsBuffer_enc);
	fooUnsupported = (fooUnsupported_client_proc_t)(enc_unsupported);
}
