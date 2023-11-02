#include <yt/yt/library/webassembly/api/function.h>

namespace NYT::NWebAssembly {

////////////////////////////////////////////////////////////////////////////////

namespace NDetail {

void WavmInvoke(
    IWebAssemblyCompartment*,
    TWebAssemblyRuntimeType,
    TCompartmentFunctionId,
    TWavmPodValue*,
    TRange<TWavmPodValue>)
{
    YT_UNIMPLEMENTED();
}

} // namespace NDetail

////////////////////////////////////////////////////////////////////////////////

} // namespace NYT::NWebAssembly