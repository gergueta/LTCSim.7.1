// compatibility defs for PC, used in UNIX

#define R_OK 04
#define W_OK 02

#define S_IRUSR		_S_IREAD
#define S_IRGRP		_S_IREAD
#define S_IROTH		_S_IREAD
#define S_IWUSR		_S_IWRITE
#define S_IWGRP		_S_IWRITE
#define S_IWOTH		_S_IWRITE
#define S_IXUSR		0
#define S_IXGRP		0
#define S_IXOTH		0
#define S_IRWXU		_S_IREAD | _S_IWRITE
#define S_IRWXG		_S_IREAD | _S_IWRITE

#define O_CREAT		_O_CREAT
#define O_EXCL		_O_EXCL
