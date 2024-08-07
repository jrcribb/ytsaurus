#pragma once

#include "public.h"

#include <yt/yt/core/logging/log.h>

namespace NYT::NJobAgent {

////////////////////////////////////////////////////////////////////////////////

YT_DEFINE_GLOBAL(const NLogging::TLogger, JobAgentServerLogger, "JobAgent");

////////////////////////////////////////////////////////////////////////////////

} // namespace NYT::NJobAgent
