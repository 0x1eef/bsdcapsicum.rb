# frozen_string_literal: true

module BSD::Capsicum
  ##
  # The constants found in this module are defined
  # by sys/capsicum.h and sys/caprights.h. Their
  # documentation can be found in the
  # [rights(4)](https://man.freebsd.org/cgi/man.cgi?query=rights&apropos=0&sektion=4&format=html)
  # man page, and they can be used with methods
  # such as {BSD::Capsicum#limit! BSD::Capsicum#limit!}
  module Constants
    CAP_RIGHTS_VERSION = 0x0

    ##
    # @group File capabilties
    CAP_READ           = FFI::CAP_READ
    CAP_WRITE          = FFI::CAP_WRITE
    CAP_SEEK           = FFI::CAP_SEEK
    CAP_PREAD          = FFI::CAP_PREAD
    CAP_PWRITE         = FFI::CAP_PWRITE
    CAP_MMAP           = FFI::CAP_MMAP
    CAP_CREATE         = FFI::CAP_CREATE
    CAP_FEXECVE        = FFI::CAP_FEXECVE
    CAP_FSYNC          = FFI::CAP_FSYNC
    CAP_FTRUNCATE      = FFI::CAP_FTRUNCATE
    CAP_FCHFLAGS       = FFI::CAP_FCHFLAGS
    CAP_FCHMOD         = FFI::CAP_FCHMOD
    CAP_FCHMODAT       = FFI::CAP_FCHMODAT
    CAP_FCHOWN         = FFI::CAP_FCHOWN
    CAP_FCHOWNAT       = FFI::CAP_FCHOWNAT
    CAP_FLOCK          = FFI::CAP_FLOCK
    CAP_FPATHCONF      = FFI::CAP_FPATHCONF
    CAP_FSTAT          = FFI::CAP_FSTAT
    CAP_FSTATAT        = FFI::CAP_FSTATAT
    CAP_FSTATFS        = FFI::CAP_FSTATFS
    CAP_FUTIMES        = FFI::CAP_FUTIMES
    CAP_FUTIMESAT      = FFI::CAP_FUTIMESAT
    # @endgroup

    ##
    # @group Socket capabilities
    CAP_ACCEPT         = FFI::CAP_ACCEPT
    CAP_BIND           = FFI::CAP_BIND
    CAP_CONNECT        = FFI::CAP_CONNECT
    CAP_GETPEERNAME    = FFI::CAP_GETPEERNAME
    CAP_GETSOCKNAME    = FFI::CAP_GETSOCKNAME
    CAP_GETSOCKOPT     = FFI::CAP_GETSOCKOPT
    CAP_LISTEN         = FFI::CAP_LISTEN
    CAP_PEELOFF        = FFI::CAP_PEELOFF
    CAP_RECV           = FFI::CAP_RECV
    CAP_SEND           = FFI::CAP_SEND
    CAP_SETSOCKOPT     = FFI::CAP_SETSOCKOPT
    CAP_SHUTDOWN       = FFI::CAP_SHUTDOWN
    CAP_BINDAT         = FFI::CAP_BINDAT
    CAP_SOCK_CLIENT    = FFI::CAP_SOCK_CLIENT
    CAP_SOCK_SERVER    = FFI::CAP_SOCK_SERVER
    # @endgroup

    ##
    # @group ACL capabilities
    CAP_ACL_CHECK      = FFI::CAP_ACL_CHECK
    CAP_ACL_DELETE     = FFI::CAP_ACL_DELETE
    CAP_ACL_GET        = FFI::CAP_ACL_GET
    CAP_ACL_SET        = FFI::CAP_ACL_SET
    # @endgroup

    ##
    # @group Process capabilities
    CAP_PDGETPID       = FFI::CAP_PDGETPID
    CAP_PDKILL         = FFI::CAP_PDKILL
    CAP_PDWAIT         = FFI::CAP_PDWAIT
    # @endgroup

    ##
    # @group Uncategorized capabilities
    CAP_CHFLAGSAT      = FFI::CAP_CHFLAGSAT
    CAP_EVENT          = FFI::CAP_EVENT
    CAP_IOCTL          = FFI::CAP_IOCTL
    CAP_KQUEUE         = FFI::CAP_KQUEUE
    CAP_LOOKUP         = FFI::CAP_LOOKUP
    CAP_MAC_GET        = FFI::CAP_MAC_GET
    CAP_MAC_SET        = FFI::CAP_MAC_SET
    CAP_MKDIRAT        = FFI::CAP_MKDIRAT
    CAP_MKFIFOAT       = FFI::CAP_MKFIFOAT
    CAP_MKNODAT        = FFI::CAP_MKNODAT
    CAP_SEM_GETVALUE   = FFI::CAP_SEM_GETVALUE
    CAP_SEM_POST       = FFI::CAP_SEM_POST
    CAP_SEM_WAIT       = FFI::CAP_SEM_WAIT
    CAP_TTYHOOK        = FFI::CAP_TTYHOOK
    CAP_UNLINKAT       = FFI::CAP_UNLINKAT
    CAP_FSCK           = FFI::CAP_FSCK
    CAP_FCHDIR         = FFI::CAP_FCHDIR
    CAP_FCNTL          = FFI::CAP_FCNTL
    # @endgroup

    # @group Sizes
    SIZEOF_CAP_RIGHTS_T = 16
    # @endgroup
  end
end
