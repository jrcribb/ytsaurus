#include "profiling_helpers.h"

namespace NYT::NConcurrency {

using namespace NProfiling;

////////////////////////////////////////////////////////////////////////////////

TTagSet GetThreadTags(
    const TString& threadName)
{
    TTagSet tags;
    tags.AddTag(TTag("thread", threadName));
    return tags;
}

TTagSet GetBucketTags(
    const TString& threadName,
    const TString& bucketName)
{
    TTagSet tags;

    tags.AddTag(TTag("thread", threadName));
    tags.AddTag(TTag("bucket", bucketName), -1);

    return tags;
}

TTagSet GetQueueTags(
    const TString& threadName,
    const TString& bucketName,
    const TString& queueName)
{
    TTagSet tags;

    tags.AddTag(TTag("thread", threadName));
    tags.AddTag(TTag("bucket", bucketName), -1);
    tags.AddTag(TTag("queue", queueName), -1);

    return tags;
}

////////////////////////////////////////////////////////////////////////////////

} // namespace NYT::NConcurrency

