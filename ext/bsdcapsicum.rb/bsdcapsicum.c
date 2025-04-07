#include <sys/capsicum.h>
#include <ruby.h>

void
Init_bsdcapsicum(void)
{
    VALUE rb_mBSD = rb_const_get(rb_cObject, rb_intern("BSD"));
    VALUE rb_mCapsicum = rb_const_get(rb_mBSD, rb_intern("Capsicum"));
    VALUE rb_mFFI = rb_define_module_under(rb_mCapsicum, "FFI");

    // @group File
    rb_define_const(rb_mFFI, "CAP_READ", LONG2NUM(CAP_READ));
    rb_define_const(rb_mFFI, "CAP_WRITE", LONG2NUM(CAP_WRITE));
    rb_define_const(rb_mFFI, "CAP_SEEK", LONG2NUM(CAP_SEEK));
    rb_define_const(rb_mFFI, "CAP_PREAD", LONG2NUM(CAP_PREAD));
    rb_define_const(rb_mFFI, "CAP_PWRITE", LONG2NUM(CAP_PWRITE));
    rb_define_const(rb_mFFI, "CAP_MMAP", LONG2NUM(CAP_MMAP));
    rb_define_const(rb_mFFI, "CAP_CREATE", LONG2NUM(CAP_CREATE));
    rb_define_const(rb_mFFI, "CAP_FEXECVE", LONG2NUM(CAP_FEXECVE));
    rb_define_const(rb_mFFI, "CAP_FSYNC", LONG2NUM(CAP_FSYNC));
    rb_define_const(rb_mFFI, "CAP_FTRUNCATE", LONG2NUM(CAP_FTRUNCATE));
    rb_define_const(rb_mFFI, "CAP_FCHFLAGS", LONG2NUM(CAP_FCHFLAGS));
    rb_define_const(rb_mFFI, "CAP_FCHMOD", LONG2NUM(CAP_FCHMOD));
    rb_define_const(rb_mFFI, "CAP_FCHMODAT", LONG2NUM(CAP_FCHMODAT));
    rb_define_const(rb_mFFI, "CAP_FCHOWN", LONG2NUM(CAP_FCHOWN));
    rb_define_const(rb_mFFI, "CAP_FCHOWNAT", LONG2NUM(CAP_FCHOWNAT));
    rb_define_const(rb_mFFI, "CAP_FLOCK", LONG2NUM(CAP_FLOCK));
    rb_define_const(rb_mFFI, "CAP_FPATHCONF", LONG2NUM(CAP_FPATHCONF));
    rb_define_const(rb_mFFI, "CAP_FSTAT", LONG2NUM(CAP_FSTAT));
    rb_define_const(rb_mFFI, "CAP_FSTATAT", LONG2NUM(CAP_FSTATAT));
    rb_define_const(rb_mFFI, "CAP_FSTATFS", LONG2NUM(CAP_FSTATFS));
    rb_define_const(rb_mFFI, "CAP_FUTIMES", LONG2NUM(CAP_FUTIMES));
    rb_define_const(rb_mFFI, "CAP_FUTIMESAT", LONG2NUM(CAP_FUTIMESAT));
    // @endgroup

    // @group Sockets
    rb_define_const(rb_mFFI, "CAP_ACCEPT", LONG2NUM(CAP_ACCEPT));
    rb_define_const(rb_mFFI, "CAP_BIND", LONG2NUM(CAP_BIND));
    rb_define_const(rb_mFFI, "CAP_CONNECT", LONG2NUM(CAP_CONNECT));
    rb_define_const(rb_mFFI, "CAP_GETPEERNAME", LONG2NUM(CAP_GETPEERNAME));
    rb_define_const(rb_mFFI, "CAP_GETSOCKNAME", LONG2NUM(CAP_GETSOCKNAME));
    rb_define_const(rb_mFFI, "CAP_GETSOCKOPT", LONG2NUM(CAP_GETSOCKOPT));
    rb_define_const(rb_mFFI, "CAP_LISTEN", LONG2NUM(CAP_LISTEN));
    rb_define_const(rb_mFFI, "CAP_PEELOFF", LONG2NUM(CAP_PEELOFF));
    rb_define_const(rb_mFFI, "CAP_RECV", LONG2NUM(CAP_RECV));
    rb_define_const(rb_mFFI, "CAP_SEND", LONG2NUM(CAP_SEND));
    rb_define_const(rb_mFFI, "CAP_SETSOCKOPT", LONG2NUM(CAP_SETSOCKOPT));
    rb_define_const(rb_mFFI, "CAP_SHUTDOWN", LONG2NUM(CAP_SHUTDOWN));
    rb_define_const(rb_mFFI, "CAP_BINDAT", LONG2NUM(CAP_BINDAT));
    rb_define_const(rb_mFFI, "CAP_SOCK_CLIENT", LONG2NUM(CAP_SOCK_CLIENT));
    rb_define_const(rb_mFFI, "CAP_SOCK_SERVER", LONG2NUM(CAP_SOCK_SERVER));
    // @endgroup

    // @group ACL
    rb_define_const(rb_mFFI, "CAP_ACL_CHECK", LONG2NUM(CAP_ACL_CHECK));
    rb_define_const(rb_mFFI, "CAP_ACL_DELETE", LONG2NUM(CAP_ACL_DELETE));
    rb_define_const(rb_mFFI, "CAP_ACL_GET", LONG2NUM(CAP_ACL_GET));
    rb_define_const(rb_mFFI, "CAP_ACL_SET", LONG2NUM(CAP_ACL_SET));
    // @endgroup

    // @group Process
    rb_define_const(rb_mFFI, "CAP_PDGETPID", LONG2NUM(CAP_PDGETPID));
    rb_define_const(rb_mFFI, "CAP_PDKILL", LONG2NUM(CAP_PDKILL));
    rb_define_const(rb_mFFI, "CAP_PDWAIT", LONG2NUM(CAP_PDWAIT));
    // @endgroup

    // @group Misc
    rb_define_const(rb_mFFI, "CAP_CHFLAGSAT", LONG2NUM(CAP_CHFLAGSAT));
    rb_define_const(rb_mFFI, "CAP_EVENT", LONG2NUM(CAP_EVENT));
    rb_define_const(rb_mFFI, "CAP_IOCTL", LONG2NUM(CAP_IOCTL));
    rb_define_const(rb_mFFI, "CAP_KQUEUE", LONG2NUM(CAP_KQUEUE));
    rb_define_const(rb_mFFI, "CAP_LOOKUP", LONG2NUM(CAP_LOOKUP));
    rb_define_const(rb_mFFI, "CAP_MAC_GET", LONG2NUM(CAP_MAC_GET));
    rb_define_const(rb_mFFI, "CAP_MAC_SET", LONG2NUM(CAP_MAC_SET));
    rb_define_const(rb_mFFI, "CAP_MKDIRAT", LONG2NUM(CAP_MKDIRAT));
    rb_define_const(rb_mFFI, "CAP_MKFIFOAT", LONG2NUM(CAP_MKFIFOAT));
    rb_define_const(rb_mFFI, "CAP_MKNODAT", LONG2NUM(CAP_MKNODAT));
    rb_define_const(rb_mFFI, "CAP_SEM_GETVALUE", LONG2NUM(CAP_SEM_GETVALUE));
    rb_define_const(rb_mFFI, "CAP_SEM_POST", LONG2NUM(CAP_SEM_POST));
    rb_define_const(rb_mFFI, "CAP_SEM_WAIT", LONG2NUM(CAP_SEM_WAIT));
    rb_define_const(rb_mFFI, "CAP_TTYHOOK", LONG2NUM(CAP_TTYHOOK));
    rb_define_const(rb_mFFI, "CAP_UNLINKAT", LONG2NUM(CAP_UNLINKAT));
    rb_define_const(rb_mFFI, "CAP_FSCK", LONG2NUM(CAP_FSCK));
    rb_define_const(rb_mFFI, "CAP_FCHDIR", LONG2NUM(CAP_FCHDIR));
    rb_define_const(rb_mFFI, "CAP_FCNTL", LONG2NUM(CAP_FCNTL));
    rb_define_const(rb_mFFI, "CAP_RIGHTS_VERSION", LONG2NUM(CAP_RIGHTS_VERSION));
    // @endgroup
}
