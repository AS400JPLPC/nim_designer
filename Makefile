# nom de l'executable :
PROJET = $(PGM)


# Adresse des sources, des objets et des includes :
SRCDIR = $(CURDIR)/src/
OBJDIR = $(CURDIR)/obj/
BINDIR = $(CURDIR)/


INCLUDES =\
-I`pkg-config --cflags vte-2.91` \
-I$(SRCDIR)

INCLIB =\
`pkg-config vte-2.91 --libs`



#/usr/lib/x86_64-linux-gnu/libdl.so

OBJ = $(OBJDIR)$(PROJET).o
RESULT = $(BINDIR)$(PROJET)



# choix du compilateur :
CXX = g++

# options compilations : voir vte-dev  -Wextra -Wno-unused-parameter   use juste for debug only for you  -Os -s
# -------------------------------------------------------------------
#  production
# -------------------------------------------------------------------
ifeq ($(PROD), true)
 CPPFLAGS=	-std=c++17 \
 	-Wall	-fexceptions	-pedantic-errors	-Wno-parentheses	-Waddress	\
 			-Wsign-compare -fpermissive 	-fstack-clash-protection	-fstack-protector-all \
 			`pkg-config --cflags vte-2.91`
#  -no-pie because it's the master program of the project so the caller  `pkg-config gmodule-2.0 --libs`
LDFLAGS =	-lX11 -no-pie `pkg-config --libs vte-2.91`

OPTIMIZE = -fexpensive-optimizations -Os -s

# -------------------------------------------------------------------
#  debug	-fno-omit-frame-pointer
# -------------------------------------------------------------------

else
CPPFLAGS=	-std=c++17 -ggdb -g3  \
			-Wall	-fexceptions	-pedantic-errors	-Wno-parentheses	-Waddress \
			-Wsign-compare -fpermissive \
			`pkg-config --cflags vte-2.91`

LDFLAGS =	-lX11   -no-pie  `pkg-config --libs vte-2.91`

OPTIMIZE =
endif
# -------------------------------------------------------------------
#  compilation
# -------------------------------------------------------------------
# compilation obj :  ex  #@echo "$(OBJCPP)"
#
# debug -v   prod [ on enleve les symboles -s & compression ...]


# regle edition de liens
all: $(OBJ)
	$(CXX)  $(OBJ) -o $(RESULT) $(OPTIMIZE) $(LDFLAGS) $(INCLIB)

ifeq ($(PROD), true)
	rm	-rf	$(OBJDIR)$(PROJET).o
endif

# regle de compilation des sources objet
$(OBJDIR)%.o: $(SRCDIR)%.cpp
	$(CXX) $(CPPFLAGS) $(INCLUDES)  -o $@ -c $<



# pour effacer tous les objets :
clean:
	rm -rf  $(OBJDIR)*.o
	rm -rf  $(RESULT)
