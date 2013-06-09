#include "sysinf.h"
#include "operatingsystem.h"

#include <qdeclarative.h>

void SysInf::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("SysInf"));
    qmlRegisterUncreatableType<OperatingSystem>(uri, 1, 0, "OperatingSystem", "");
    //qmlRegisterUncreatableType<AUIMDialogStatus>(uri, 1, 0, "AUIDialogStatus", "");
}

Q_EXPORT_PLUGIN2(sysinf, SysInf)
