/****************************************************************************
** Meta object code from reading C++ file 'landedtorch.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../landedtorch.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'landedtorch.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_LandedTorch[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      13,   12,   12,   12, 0x0a,
      26,   12,   12,   12, 0x0a,
      36,   12,   12,   12, 0x0a,
      47,   12,   12,   12, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_LandedTorch[] = {
    "LandedTorch\0\0initialize()\0torchOn()\0"
    "torchOff()\0torchToggle()\0"
};

void LandedTorch::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        LandedTorch *_t = static_cast<LandedTorch *>(_o);
        switch (_id) {
        case 0: _t->initialize(); break;
        case 1: _t->torchOn(); break;
        case 2: _t->torchOff(); break;
        case 3: _t->torchToggle(); break;
        default: ;
        }
    }
    Q_UNUSED(_a);
}

const QMetaObjectExtraData LandedTorch::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject LandedTorch::staticMetaObject = {
    { &QDeclarativeItem::staticMetaObject, qt_meta_stringdata_LandedTorch,
      qt_meta_data_LandedTorch, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &LandedTorch::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *LandedTorch::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *LandedTorch::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_LandedTorch))
        return static_cast<void*>(const_cast< LandedTorch*>(this));
    return QDeclarativeItem::qt_metacast(_clname);
}

int LandedTorch::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDeclarativeItem::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
