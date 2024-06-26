#pragma once

#include "public.h"

#include <yt/yt/core/logging/log.h>

namespace NYT::NS3 {

////////////////////////////////////////////////////////////////////////////////

YT_DEFINE_GLOBAL(const NLogging::TLogger, S3Logger, "S3");

////////////////////////////////////////////////////////////////////////////////

} // namespace NYT::NS3
