#pragma once

#include "public.h"

namespace NYT::NRpcProxy {

////////////////////////////////////////////////////////////////////////////////

struct IAccessChecker
    : public TRefCounted
{
    virtual TError CheckAccess(const std::string& user) const = 0;
};

DEFINE_REFCOUNTED_TYPE(IAccessChecker)

////////////////////////////////////////////////////////////////////////////////

IAccessCheckerPtr CreateNoopAccessChecker();

////////////////////////////////////////////////////////////////////////////////

} // namespace NYT::NRpcProxy
