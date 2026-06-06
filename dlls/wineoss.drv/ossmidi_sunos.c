/*
 * illumos/OpenIndiana: no legacy OSS sequencer API (Linux /dev/sequencer).
 * Stub MIDI unixlib so wineoss.drv still builds; PCM audio uses oss.c/mmdevdrv.c.
 */
#if 0
#pragma makedep unix
#endif

#include "config.h"

#include <stdarg.h>

#include "ntstatus.h"
#define WIN32_NO_STATUS
#include "winternl.h"
#include "audioclient.h"
#include "mmddk.h"

#include "unixlib.h"

NTSTATUS oss_midi_release(void *args)
{
    return STATUS_SUCCESS;
}

static UINT midi_stub_err(UINT msg, UINT *err)
{
    switch (msg)
    {
    case DRVM_INIT:
        *err = MMSYSERR_NODRIVER;
        return *err;
    case DRVM_EXIT:
    case DRVM_ENABLE:
    case DRVM_DISABLE:
        *err = MMSYSERR_NOERROR;
        return *err;
    default:
        *err = MMSYSERR_NOTENABLED;
        return *err;
    }
}

NTSTATUS oss_midi_out_message(void *args)
{
    struct midi_out_message_params *params = args;

    params->notify->send_notify = FALSE;
    if (params->msg == MODM_GETNUMDEVS)
    {
        *params->err = 0;
        return STATUS_SUCCESS;
    }
    midi_stub_err(params->msg, params->err);
    return STATUS_SUCCESS;
}

NTSTATUS oss_midi_in_message(void *args)
{
    struct midi_in_message_params *params = args;

    params->notify->send_notify = FALSE;
    if (params->msg == MIDM_GETNUMDEVS)
    {
        *params->err = 0;
        return STATUS_SUCCESS;
    }
    midi_stub_err(params->msg, params->err);
    return STATUS_SUCCESS;
}

NTSTATUS oss_midi_notify_wait(void *args)
{
    struct midi_notify_wait_params *params = args;

    *params->quit = TRUE;
    params->notify->send_notify = FALSE;
    return STATUS_SUCCESS;
}
