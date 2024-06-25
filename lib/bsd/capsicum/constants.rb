module BSD::Capsicum
  ##
  # The constants found in this module are defined
  # by sys/capsicum.h and sys/caprights.h. Their
  # documentation can be found in the
  # [rights(4)](https://man.freebsd.org/cgi/man.cgi?query=rights&apropos=0&sektion=4&format=html)
  # man page
  module Constants
    CAP_RIGHTS_VERSION = 0x0

    ##
    # @group General file capabilties
    CAP_READ           = 0x200000000000001
    CAP_WRITE          = 0x200000000000002
    CAP_SEEK           = 0x20000000000000c
    CAP_PREAD          = 0x20000000000000d
    CAP_PWRITE         = 0x20000000000000e
    CAP_MMAP           = 0x200000000000010
    CAP_CREATE         = 0x200000000000040
    CAP_FEXECVE        = 0x200000000000080
    CAP_FSYNC          = 0x200000000000100
    CAP_FTRUNCATE      = 0x200000000000200
    # @endgroup

    ##
    # @group Socket capabilities
    CAP_ACCEPT         = 0x200000020000000
    CAP_BIND           = 0x200000040000000
    CAP_CONNECT        = 0x200000080000000
    CAP_GETPEERNAME    = 0x200000100000000
    CAP_GETSOCKNAME    = 0x200000200000000
    CAP_GETSOCKOPT     = 0x200000400000000
    CAP_LISTEN         = 0x200000800000000
    CAP_PEELOFF        = 0x200001000000000
    CAP_RECV           = CAP_READ
    CAP_SEND           = CAP_WRITE
    CAP_SETSOCKOPT     = 0x200002000000000
    CAP_SHUTDOWN       = 0x200004000000000
    CAP_BINDAT         = 0x200008000000400
    CAP_SOCK_CLIENT    = 0x200007780000003
    CAP_SOCK_SERVER    = 0x200007f60000003
    # @endgroup

    ##
    # @group ACL capabilities
    CAP_ACL_CHECK      = 0x400000000010000
    CAP_ACL_DELETE     = 0x400000000020000
    CAP_ACL_GET        = 0x400000000040000
    CAP_ACL_SET        = 0x400000000080000
    # @endgroup

    ##
    # @group Process capabilities
    CAP_PDGETPID       = 0x400000000000200
    CAP_PDKILL         = 0x400000000000800
    CAP_PDWAIT         = 0x400000000000400
    # @endgroup

    ##
    # @group Uncategorized capabilities
    CAP_CHFLAGSAT      = 0x200000000001400
    CAP_EVENT          = 0x400000000000020
    CAP_FCHDIR         = 0x200000000000800
    CAP_FCHFLAGS       = 0x200000000001000
    CAP_FCHMOD         = 0x200000000002000
    CAP_FCHMODAT       = 0x200000000002400
    CAP_FCHOWN         = 0x200000000004000
    CAP_FCHOWNAT       = 0x200000000004400
    CAP_FCNTL          = 0x200000000008000
    CAP_FLOCK          = 0x200000000010000
    CAP_FPATHCONF      = 0x200000000020000
    CAP_FSCK           = 0x200000000040000
    CAP_FSTAT          = 0x200000000080000
    CAP_FSTATAT        = 0x200000000080400
    CAP_FSTATFS        = 0x200000000100000
    CAP_FUTIMES        = 0x200000000200000
    CAP_FUTIMESAT      = 0x200000000200400
    CAP_IOCTL          = 0x400000000000080
    CAP_KQUEUE         = 0x400000000100040
    CAP_LOOKUP         = 0x200000000000400
    CAP_MAC_GET        = 0x400000000000001
    CAP_MAC_SET        = 0x400000000000002
    CAP_MKDIRAT        = 0x200000000800400
    CAP_MKFIFOAT       = 0x200000001000400
    CAP_MKNODAT        = 0x200000002000400
    CAP_SEM_GETVALUE   = 0x400000000000004
    CAP_SEM_POST       = 0x400000000000008
    CAP_SEM_WAIT       = 0x400000000000010
    CAP_TTYHOOK        = 0x400000000000100
    CAP_UNLINKAT       = 0x200000010000400
    # @endgroup
  end
end
