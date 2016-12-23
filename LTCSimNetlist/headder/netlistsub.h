#include <stdafx.h>
#include "pikproc.h"
#include "dataout.h"
#include <atlstr.h>
#include "LTCUtils.h"

static char list[16000] = "";
static int err = 0;
extern char cCmd_Tool;
extern int bCmd_IgnoreCase;
using namespace System;
using namespace LTCSimNetlist;

