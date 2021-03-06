C=========================================================================
      module m_gtv
C- module to read ctrl file -------------------------------
Cr gtv is the main rouitne. Its has interface.
Cr
Cr How gtv work, step by step.
Cr   0. call it with 'name' like HAM_RSRNGE and sw. See options below.
Cr   1. Af first, gtv check sw. If sw=2, exit with nout=0.
Cr   2. Then read ctrl. If readin number of data is nmin or more, normal exit.
Cr   3. If readin number of data is less, Error exit (stop) if sw=1
Cr   4.   If sw=0 (optional case) and default exist, read it and notmal exit
Cr   5.   If sw=0 (optional case) and no default, notmal exit with nout=0.
Cr
Cr   gtv( name, sw, data,
Cr       [default,cindx, note, or, nout, nmin, exist])
Cr  * default and below are optional.
Cr    So use f77 like binding for name, sw and data,
Cr    But use name-to-name binding for others.
Cr    Then f90 restriction, use defalut_*,where * is i4,i4vr8,r8v,lg.
Cr  * data can be i4 i4v r8 r8v logical char
Cr    In addition, no default in the case of char.
Cr  * In addition, basic settin in m_gtv is used: these are given by
Cr      subroutine gtv_setio(io_show_in, io_help_in)
Cr      subroutine gtv_setst(debug_in, stdo_in,stdl_in,stde_in)
Cr    These must be called before calling gtv.
Cr
Ci   name: like HAM_PMIN, SPEC_ATOM_Z and so on. _ devide tokens.
Ci         In principle, A1_A2_A3_A4 is readable, but
Ci         the grammer in ctrl file is problematic---so not so safe.
Ci     sw; sw=tksw(prgn,name)
Co   data: this is first cleared as null=-99999.
Co         data can be (i4 i4v r8 r8v logical char) types.
Co         As f90, number of data(maximum number of readin data) is
Co         automatically passed to.
Ci   def_* : default values. This can be an array for i4f,r8v.
Ci               As f90, number of array is recognized.
Ci   cindx: is now (/1,j/), j is a integer --- this is used for SPEC and SITE.
Ci          cindx specify j-th atom of second token (ATOM for SPEC_ATOM_Z).
Ci   note: note for input help
Ci     or: just for input help mode. Show "OR" if or=.true. default=.false.
Co   nout: how many data are output. zero can be.
Ci   nmin: gtv fails to read ctrl if gtv can not read nmin or more data.
Ci         nmin=0 is possible. default=1.
Co  exist: if the given name is found, exist=.true.
C ---------------------------------------------------------------
      implicit none
      integer,parameter,private :: nrcd=600000
      character(nrcd),private:: rcd  !ifc henry is strange
C     character(nrcd),allocatable,private:: rcd(1)

      integer,private:: io_show,io_help,stdo,stdl,stde
      logical,private::  debug=.false.
      interface gtv
      module procedure
     .gtv_r8,gtv_i4,gtv_r8v,gtv_i4v,gtv_char,gtv_lg,gtv_none
      end interface

      interface getinput
      module procedure
     .getinput_r8,getinput_i4,getinput_r8v,getinput_i4v,
     .getinput_char,getinput_none
      end interface

      contains
      subroutine gtv_setio(debug_in,io_show_in,io_help_in)
C- Set io_show and io_help for m_gtv
      implicit none
      logical::  debug_in
      integer:: io_show_in,io_help_in
      debug   = debug_in
      io_show = io_show_in
      io_help = io_help_in
      end subroutine

      subroutine replacetab2space( recrd,recln )
      integer:: i,recln
      character*(*):: recrd
      do i = 1, recln
        if(recrd(i:i)==char(9)) recrd(i:i)=' '
      enddo
      end subroutine

      subroutine gtv_setrcd(recrd,nrecs,recln)
C- Copy contents of fixed-length input file to local rcd
C ----------------------------------------------------------------------
Ci Inputs
Ci   recrd
Ci   nrecs :number of records
Ci   recln :size of record
Co Outputs
Cl Local variables
Cl         :
Cr Remarks
Cr   contents of record are copied, with markers for EOL
Cu Updates
Cu   13 Oct 07
C ----------------------------------------------------------------------
      implicit none
C ... Passed parameters
      integer nrecs,recln
      character*(*) recrd
C ... Local parameters
      integer i,ioff,ioff2,j,l
C     real(8) cpusec

C     print *, cpusec()
      rcd = ' '
      ioff2 = 1
      do  i = 1, nrecs
        ioff = (i-1)*recln + 1

Ctakao replace tab to space. 7thJune2010.
        call replacetab2space(recrd(ioff:i*recln),recln)

C       Blank line; skip
        if (recrd(ioff:ioff)=='#' .or. recrd(ioff:ioff)=='!') then
C       No character in 1st column
        elseif (recrd(ioff:ioff)==' ') then
C         The next two lines work, but they are too slow
C         rcd(ioff2+1:) = adjustl(recrd(ioff:ioff+recln-1))
C         ioff2 = len_trim(rcd)+1
C         Replace preceding 2 lines with the following loop
          do  j = ioff,ioff+recln-1
            if (recrd(j:j) .ne. ' ') then
              l = len_trim(recrd(j:ioff+recln-1))
              rcd(ioff2+1:) = recrd(j:j+l-1)
              ioff2 = ioff2 + l+1
              exit
            endif
          enddo
C       Character in 1st col: add @CAT@ to mark category delimiter
        else
C         Replace CLASS with SPEC
          if (recrd(ioff:ioff+4) .eq. 'CLASS') then
            recrd(ioff:ioff+4) = 'SPEC'
          endif
          write(rcd(ioff2:ioff2+recln-1+6),"(1x,a,a)")
     .    '@CAT@',recrd(ioff:ioff+recln-1)
          ioff2 = len_trim(rcd)+1
        endif
C       write(*,"(i4,a)") ioff, rcd(1:ioff2)
      enddo
      rcd(ioff2:) = ' @CAT@EOF'
ccccccccccccccccccccccccc
c      print *,'rrrrrrrrrrrrrrrrrrrrrrrrcd=',trim(rcd)
cccccccccccccccccccccccccc

C     print *, cpusec()
C     print *, ioff2; stop
      ioff2 = ioff2+9
      if (ioff2 > nrcd)
     .call rxi('m_gtv: increase size of rcd; need at least',ioff2)

      end subroutine

      subroutine gtv_setst(stdo_in,stdl_in,stde_in)
C- Set stdo,stdl,stde in m_gtv
      implicit none
      integer:: stdo_in,stdl_in,stde_in
C     character*(*):: rcd_in
C     if(len(trim(rcd_in))>nrcd) stop 'm_gtv: enlarge size of rcd'
      stdo = stdo_in
      stdl = stdl_in
      stde = stde_in
C     rcd = trim(rcd_in)
c     write(stdo,*) 'tokse_setst:', trim(rcd)

      end subroutine

      subroutine gtv_entrance()
C- General purpose routine to read token contents
C  True entry points are gtv_r8,gtv_r8v,gtv_i4,gtv_i4v,gtv_lg,gtv_char,gtv_none
C ----------------------------------------------------------------------
Ci Inputs (required)
Ci  name   :string defining a token 'tree'.
Ci         :It delimits a region where data is to be read; See Remarks
Ci    sw   :sw=0: Token's presence is optional
Ci         :sw=1: Token's presence is required
Ci         :sw=2: Token's presence is ignored
Ci Inputs (optional)
Ci  cindx  :used when multiple instances of data are used for
Ci         :a particular token e.g. multiple species data.
Ci         :Token region corresponds to cindx-th occurrence of token
Ci         :If cindx exists, the how the end of the token's contents
Ci         :is determined is described in Remarks, case D.
Ci
Ci  note   :string for help printout
Ci
Ci    or   :if present, help printout flags that a later token
Ci         :may be alternately read to supply substitute information
Ci
Ci  nmin   :minimum number of elements that must be input EITHER from
Ci         :the token contents, OR supplied as default values.
Ci         :nmin's function depends on whether default values are supplied.
Ci         :Finally, whether nmin is used at all or not depends on sw
Ci         :See Examples below.
Ci         :nmin is supplied as one of these possibilities:
Ci         :  not present  or  nmin=0   or   nmin>0   or   nmin<0
Ci         :|nmin| corresponds to how many values must be returned.
Ci         :The sign of nmin has a special meaning; see below;
Ci
Ci         :Case defaults ARE supplied:
Ci         :1. nmin=(not present): gtv uses internally nmin=1
Ci                         gtv fills data after last parsed entry with
Ci                         default values.
Ci         :2. nmin=0      Not necessary that any values be parsed
Ci                         gtv fills data after last parsed entry with
Ci                         default values.
Ci         :3. nmin>0      Same as case 1.
Ci                         Note: nonsensical for nmin>nndef where
Ci                         nndef = number of default values passed.
Ci         :4. nmin<0      If a token is present, at least |nmin| values
Ci                         must be parsed, regardless of nndef
Ci
Ci         :Case defaults ARE NOT supplied:
Ci         :1. nmin=(not present): gtv uses internally nmin=1
Ci                         gtv fills data after last parsed entry with NULLI
Ci         :2. nmin=0      Not necessary that any values be parsed
Ci         :3. nmin>0      If a token is present, at least |nmin| values
Ci                         must be parsed
Ci         :4. nmin<0      Same as nmin>0
Ci
Ci         :Help mode: Pass nmin=NULLI together with io_show=1 =>
Ci         :size of input is unknown
Ci
Ci         :Character input: nmin has different meaning.
Ci         :1s digit: 0 => no string need be present
Ci         :        : 1 => a nonblank string must be read
Ci         :10s digit affects how character string is delimited
Ci         :Not used if quote marks delimit string ("'" or `"')
Ci         :Otherwise: 10s digit means:
Ci         :0  string delimited by token's region.  See Remarks below,
Ci             description below of *For character input, option 2.
Ci         :1  end-of-string delimited by first blank after start-of-string
Ci             See Remarks below, description below of *For character input,
Ci             option 3
Ci
Ci def_r8,def_r8v,def_i4,def_i4v,def_lg:
Ci         :Default values for input data.  If fewer than nmin elements
Ci         :are read from input, these default values may substitute,
Ci         :if they exist.  At most nmin elements in the default array
Ci         :are used.
Ci         :NB: Pass def_*(1)=NULL => default value depends on other input
Ci         :Works for real and integer input.
Ci
Co Outputs
Co dat,datv,idat,idatv,lg,char: are all the third argument of the
Co         :generic entry point gtv.  They differ in their cast.
Co         :Only one is used.  Input is stored into this argument.
Co         :The dimension of this argument sets how many elements
Co         :gtv will attempt to read.
Co Outputs (optional)
Co    nout :number of elements read into dat (or its equivalent),
Co         :either from the input file, or assigned by default
Co         :nout returned -1 if nothing sought (sw=2)
Co  Texist :Returns information about whether token found or not
Co         :If sw==2, always return Texist=F.  Otherwise:
Co         :If io_help>0, always return Texist=T.  Otherwise:
Co         :If token found, return Texist=T
Co         :If token not found, return Texist=F
Co         :Texist is only set if variable is present
Cl Local variables
Cl  ig     :string defining cast of object
Cl  nndef  :size of (number of elements in) default array
Cl  nminl  :nminl=|nmin|, if nmin exists; otherwise nminl=1
Cl  sizez  :number of elements in result array; number of elements to read
Cl  cindx2 :local copy of cindx(2), if it exists.
Cl         :otherwise, -1
Cr Remarks
Cr   'name' is a tree of tokens, with elements separated by underscores, e.g.
Cr     'HAM_TOL'  or  'SPEC_ATOM_Z'
Cr
Cr   The top-level token is called the 'category'.  In the second example
Cr   it is 'SPEC'; the second and third level tokens are 'ATOM' and 'Z'.
Cr   We will call the token of the preceding level the 'parent' token.  In
Cr   the example, 'ATOM' is the parent to 'Z'; 'SPEC' is the parent to 'ATOM'.
Cr
Cr   The input string is held in char variable  rcd .  rcd contains tokens
Cr   and their contents.  Following a token is a single character, the token
Cr   terminator, e.g. '=' (the terminator's value depends a little on the
Cr   context.)  The "data region" follows the token terminator, in a
Cr   substring rcd(i1:ie).  The rules for starting and end delimiters i1
Cr   and ie can depend on the context; see  *Finding a token and
Cr   *End delimiter below.
Cr
Cr   Tokens and their data regions are embedded within the region of the
Cr   parent.  Thus the region of 'SPEC_ATOM_Z' is contained within the
Cr   region of 'SPEC_ATOM,' which is in turn contained within the region
Cr   'SPEC'.  This means that the regions corresponding to tokens of the
Cr   same name but members of different trees, eg TOL in the HAM_TOL and
Cr   MIX_TOL, will be different and not overlap.
Cr
Cr   *Finding a token and the beginning of its data region
Cr   1.  Categories (top-level tokens) have a special syntax.
Cr       From the user's point of view, a new category begins whenever a
Cr       new line in the input file begins with a nonblank character.
Cr       The region of the category ends where the next new category starts.
Cr
Cr       The computer handles this by checking each input line.  Any line
Cr       which begins with a nonblank character has string @CAT@ prepended
Cr       to it.  Thus the start of a category with name 'NAM' is determined
Cr       by the first occurrence of the string '@CAT@NAM ', where the last
Cr       (terminating) character is a space.  The region ends just before
Cr       the first occurence of '@CAT@' following '@CAT@NAM '.
Cr
Cr   2.  Tokens below the top level must be found between the start and end
Cr       region of its parent token. A token must have a space preceding
Cr       it.  Thus, a token with nam 'NAM' is identified by the first occurence
Cr       of the string ' NAMx' within the region of the parent token.  Here x
Cr       is the terminating character; usually x is '=' or ':'.
Cr
Cr       In cases 1 and 2, a token's contents (data region) begin after
Cr       the token terminator.  What defines the start-of-region depends
Cr       on the context.  There are two types:
Cr       a. The first nonblank character following the token is a '['
Cr          In this case, start-of-region is the first character after '['
Cr       b. start-of-region begins immmediately after the token terminator
Cr       c. The calling program may use either of these rules, or both:
Cr          rule (a) applies if the first nonblank char is '['; if not
Cr          rule (b) applies.
Cr       Note: if only rule (a) is allowed, and first nonblank char
Cr       following the token is not '[', the parser exits with an
Cr       'error-match'
Cr
Cr   *End delimiter of token region.  It determined as follows:
Cr   A.  If start-of-region is determined by rule (a) above, the region
Cr       is terminated by ']'.  Since tokens may be nested in a tree
Cr       structure, the end delimiter must be the ']' matching its
Cr       corresponding '[' It is an error for any opening '['
Cr       to be missing its corresponding ']'.
Cr
Cr   B   If the token is top-level (category), end-of-region is defined
Cr       in notes (1) above.
Cr
Cr       Otherwise:
Cr
Cr   C.  With the exception noted in D below, the end of a token's region
Cr       coincides with the end of its parent.
Cr
Cr   D.  Certain tokens are used to tag multiple instances of data,
Cr       such as site positions or species data.  In these special
Cr       cases, the nth occurence of the token must also be specified
Cr       (cindx) and the end delimiter is the SMALLER of:
Cr         the endpoint of the parent token
Cr         the character preceding next occurence of the token
Cr       Example:   Given token 'ATOM'
Cr           ATOM=A  A-contents  ATOM=B  B-contents end  ATOM=C ...
Cr       the region of the 2nd occurence is ' B-contents end  '
Cr
Cr  --- Parsing of tokens, and how missing information is handled ---
Cr  A lot of flexibility is available to handle cases when tokens are
Cr  missing, or what to do when fewer than maximum elements are read.
Cr
Cr  *'sizez' is the maximum number of elements that can be read
Cr   If a token is found, gtv will attempt to read 'sizez' elements
Cr   of data (results of numerical expressions) from token contents.

Cr  *Character input is treated specially (number of elements is meaningless)
Cr   If the first character is a quote ("'" or `"'), the string is delimited
Cr   by pairs of quotation marks; see below.
Cr
Cr  *'nmin' dictates the minimum number of elements that must be input.
Cr    "Input" can be either from token contents or defaults; see below.
Cr    If 'nmin' is not supplied, it locally takes the value 1.
Cr
Cr  If gtv succeeds in reading only k elements, with k<nmin, gtv will fill
Cr  elements k+1..nmin with default values, if caller supplies them.
Cr  If caller supplies fewer than nmin default values, gtv cannot supply
Cr  nmin elements and program aborts.
Cr
Cr  Examples:
Cr  sw nmin  # defaults  Action:
Cr   1  2      none      Token must be found; 2 expressions must be parsed
Cr                       from token contents
Cr   1  1      1         Token must be found; 1 expressions must be found;
Cr                       since a default is available, it will substitute
Cr                       if no expression is found.  Note: it is not common
Cr                       to require a token be present with the expectation
Cr                       that an expression follow, yet to be no error if
Cr                       the expression is missing.
Cr                       Still, such instances may occur.
Cr   1  2      1         Same as first example.  This is a poor combination
Cr                       of parameters.  There are fewer than nmin
Cr                       defaults; so all data must be parsed anyway.
Cr                       Better to use first example, or supply at least
Cr                       nmin default values.
Cr   0  0      none      Token need not be present.  If it is present,
Cr                       no error occurs if no expressions are parsed.
Cr                       (The expression will evaluate to NULL)
Cr   0  1      none      Token need not be present.  If it is present,
Cr                       at least one expression must be parsed.
Cr                       Another unusual combination of conditions.
Cr   0  1      1         Token need not be present.  If it is, result is
Cr                       value of expression, if one is successfully parsed.
Cr                       Otherwise, result is the supplied default value.
Cr
Cr *For character input,  'character string' corresponds to 'expression'
Cr  in the description above.
Cr  A character string may be delimited in one of three ways:
Cr  1. If first nonblank character after start-of-region is a single
Cr     or double quote ("'" or `"'), string starts after quote,
Cr     ends before next occurence of quote, or end-of-region, whichever
Cr     comes first.
Cr  2. start-of-string is first nonblank character after start-of-region
Cr     end-of-string is end-of-region (this is the default)
Cr  3. start-of-string is same as 2.
Cr     end-of-string is first blank character after start-of-string
Cr     For this option, set 10's digit nmin=2; see descr. of nmin above
Cr
Cr  Thus, sw=0, nmin=0 =>Token need not be present.  If it is present,
Cr                       no error occurs if no string is found
Cr                       (The result is empty string)
Cr        sw=0, nmin=1 =>Token need not be present.  If it is present,
Cr                       a nonblank string must be read.
Cr  At present:
Cr    There is no capability to read vectors of character strings.
Cr    No default strings can be supplied
Cr
Cu Updates
Cu   27 Jul 07
C ----------------------------------------------------------------------
      implicit none
C ... Passed parameters
      character*(*),intent(in):: name
      real(8),intent(out)     :: dat,  datv(1:)
      integer,intent(out)  :: idat,idatv(1:)
      integer,intent(in)   :: sw
      logical,optional,intent(in)::  def_lg,or
      integer,optional,intent(in)::  nmin, cindx(1:)
      character*(*),optional,intent(in):: note
      integer,optional,intent(in)::  def_i4, def_i4v(1:)
      real(8),optional,intent(in)::     def_r8, def_r8v(1:)
      logical,intent(out)     :: lg
      integer,optional,intent(out):: nout
      logical,optional,intent(out):: Texist
C ... Local parameters
      integer::  cindx2
      integer:: nn,sizez,nparse,isw,iprint
      real(8):: ddat(1000)
C     character(128*2) aaa
      character*(*):: char
      character(3)::ig
      character(256) sout
C     character(21+124):: rrrx
      logical :: lgx,lexist,lor,lrqdn
      real(8):: defa(256)
      integer:: nndef
      character(4) opts(3)
      integer:: nminl, NULLI = -99999
      integer(2),intent(in):: nono
C     A string for help printout
      data opts /'opt','reqd','skip'/

      logical:: isanrg, l_dummy_isanrg

      entry gtv_r8(name,sw,dat,def_r8,cindx,note,or,nmin,nout,Texist)
      nndef = 0; sizez = 1; defa(1) = 0d0
      if ( present(def_r8)  ) then
        nndef = 1; defa(1) = def_r8
      endif
C       not sure we want to do this ...
      if (sw .ne. 2) dat = nulli
      ig = 'r8' ;    goto 990

      entry gtv_r8v(name,sw,datv,def_r8v,cindx,note,or,nmin,nout,Texist)
      nndef = 0; sizez = size(datv); defa(1) = 0d0
      if ( present(def_r8v) ) then
        nndef = min(size(def_r8v),sizez); defa= def_r8v
      endif
      if (sw .ne. 2) datv = nulli
      ig = 'r8v' ;   goto 990

      entry gtv_i4(name,sw,idat,def_i4,cindx,note,or,nmin,nout,Texist)
      nndef = 0; sizez = 1; defa(1) = 0d0
      if ( present(def_i4)  ) then
        nndef = 1; defa(1) = def_i4
      endif
      if (sw .ne. 2) idat = nulli
      ig = 'i4';    goto 990

      entry gtv_i4v(name,sw,idatv,def_i4v,cindx,note,or,nmin,nout,
     .Texist)
      nndef = 0; sizez = size(idatv); defa(1) = 0d0
      if (present(def_i4v) ) then
        nndef = min(size(def_i4v),sizez); defa= def_i4v
      endif
      if (sw .ne. 2) idatv = nulli
      ig='i4v';    goto 990

      entry gtv_lg(name,sw,lg,def_lg,cindx,note,or,nmin,nout,Texist)
      sizez = 1; nndef = 0
      if ( present(def_lg)  ) then
        nndef = 1 ; defa(1) = isw(def_lg)
      endif
      ig='lg' ;    goto 990

      entry gtv_char(name,sw,char,cindx,note,or,nmin,nout,Texist)
      nndef = 0
      sizez = 1;   ig='chr';   goto 990

      entry gtv_none(name,sw,nono,cindx,note,or,Texist)
      nndef = 0; defa(1) = 0d0
      sizez = 0;   ig='---';   goto 990

C --- Start of statements common to all entry routines ---
  990 continue
      if (sw .eq. 2) then
        if (ig .ne. '---') then
          if (present(nout)) nout=-1
        endif
        if (present(Texist) ) Texist = .false.
C        if (debug) then
C        endif
        return
      endif
C     Assign cindx2 = cindx(2) for now
      cindx2 = -1
      if (present(cindx)) then
C       if (sum(cindx)-cindx(2)/=size(cindx)-1) !only cont(2) allowed now
        if (cindx(1) .ne. 1) call rx('gtv:  cindx(1)>1 not implemented')
        cindx2 = cindx(2)
      endif
Ckino isanrg is logical function,       call isanrg(sw,0,2,' gtv','sw',.true.)
      l_dummy_isanrg=isanrg(sw,0,2,' gtv','sw',.true.)
      nndef = min(nndef,sizez)  ! Only use defaults up to size of input

C ... Local copy of nmin that always exists
      nminl = min(1,sizez)
C     DEC fortran: nmin can exis for gtv_none, even if not in arg lst
      if (ig .ne. '---') then
        lrqdn = .false.
        if (present(nmin)) then
C       nmin<0 => nparse MUST be at least nminl
          lrqdn = nmin .lt. 0
          nminl = iabs(nmin)
          if (io_help .eq. 0 .and. (ig .ne. 'chr'))
Ckino isanrg is logical function,      .    call isanrg(iabs(nmin),-1,sizez,' gtv','nmin',.true.)
     .    l_dummy_isanrg=isanrg(iabs(nmin),-1,sizez,' gtv','nmin',.true.)
        elseif (ig .eq. 'chr') then
          nminl = 0
        endif
      endif
C ... local copy of present(or)
      lor = present(or)
      if (lor) then
        lor = or
      endif

C ... For printout
      if (debug .and. io_help.ne.0) then
C        call info2(0,0,0,' gtv:  name='//name//'; cast='//ig//
C     .    ' ... help mode',0,0)
      elseif (debug) then
        call info2(0,0,0,' gtv:  name='//name//'; cast='//ig//
     .  '%?!n>0!; contents from occurence #%-1j%i of token !!'//
     .  '%?!n>1!; attempt to read %-1j%i elements',
     .  cindx2,sizez)
      endif
      if (-nminl .eq. NULLI) then
        write(sout,
     .  "(1x,a,t20,a,3x,a,21x,'size depends on other input')")
     .  name,opts(sw+1),ig
      elseif (sizez .eq. 0) then
        write(sout,"(1x,a,t20,a,3x,a)") name,opts(sw+1),ig
      else
        write(sout,"(1x,a,t20,a,3x,a,i7,',',i3)")
     .  name,opts(sw+1),ig,sizez,mod(nminl,10)
      endif

C ... Logical case: treat locally as integer
      lgx = .false.
      if (ig == 'lg') then
        ig = 'i4'
        lgx = .true.
      endif

C  --- Help mode ---
      if (io_help .ne. 0) then
C       if (lgx .and. .false.) then
        if (lgx) then
          call info2(1,0,0,trim(sout)//
     .    '%?!(n==1)!%50pdefault = %l',nndef,defa(1).ne.0)
        elseif (nndef .ge. 1 .and. defa(1) .eq. NULLI) then
          if (nminl .eq. NULLI) then
            call info0(1,0,0,trim(sout)//
     .      '%50psize and defaults depend on other input')
          else
            call info0(1,0,0,trim(sout)//
     .      '%50pdefault depends on other input')
          endif
        elseif (nminl .eq. NULLI .and. nndef .ge. 1) then
          call info2(1,0,0,trim(sout)//
     .    '%50pdef = %g ... size depends on other input',defa,0)
        elseif (nminl .eq. NULLI) then
          call info0(1,0,0,trim(sout)//
     .    '%50psize depends on other input')
        elseif (nndef .ge. 1 .and .nndef .le. 4) then
          call info2(1,0,0,trim(sout)//'%50pdefault =%n:1g',nndef,defa)
        elseif (nndef .ge. 1) then
          call info2(1,0,0,trim(sout)//'%50pdefault =%n:1g ...',3,defa)
        else
          call info0(1,0,0,trim(sout))
        endif
        if (present(note)) then
          call info0(1,0,0,'   '//note)
        endif
        if ( lor ) then
          write(stdo,"(a)")
     .    ' * If token is not parsed, attempt to read the following:'
        endif
        if (ig .ne. '---') then
          if (present(nout)) nout=0
        endif
        if (present(Texist) ) Texist = .true.
        return
      endif

C --- Check for token match; no data input ---
      if (ig == '---') then
        call getinput(name, cindx2, lexist)
        if (present(Texist) ) Texist = lexist
C   ... Printout
        if ((io_show>0 .or. debug) .and. iprint() .ne. 0) then
          if (lexist) then
            write(sout(1+len_trim(sout):),"(27x,'present')")
          else
            write(sout(1+len_trim(sout):),"(27x,'missing')")
          endif
          write(stdo,'(a)') trim(sout)
        endif
        if (sw .eq. 1 .and. .not. lor .and. .not. lexist) then
          sout = ' gtv (abort): no token '//trim(name)//' found'
          call rx(sout)
        endif
        return
      endif

C --- Character input ---
      if (ig == 'chr') then
        char = ' '
C        call getinput(name, char, 1, cindx2, lexist, nn)
        call getinput(name, char, nminl/10, cindx2, lexist, nn)
C       print *, sout
        if ((.not. lexist .and. .not. lor. and. sw .eq. 1)) then
          sout = ' gtv (abort): no token '//trim(name)//' found'
          call rx(sout)
        elseif (lexist .and. mod(nminl,10) .gt. 0 .and. nn.eq.0) then
          sout = ' gtv (abort): no string for token '//trim(name)
          call rx(sout)
        endif
        if (present(Texist) ) Texist = lexist
        if (present(nout) ) nout = nn
C   ... Printout
        if (io_show>0 .or. debug) then
          if (.not. lexist) then
            write(sout(1+len_trim(sout):),"(',   *')")
          elseif (nn .eq. 0) then
            write(sout(1+len_trim(sout):),"(',   0')")
          else
            write(sout(1+len_trim(sout):),"(',   1')")
            sout(57:) = char
          endif
          write(stdo,'(a)') trim(sout)
        endif
        return
      endif

C --- Get token contents; try to read d.p. vector of size sizez ---
C     nparse = number of elements actually read
      call getinput(name, ddat, sizez, cindx2, lexist, nparse)
      if (present(Texist)) Texist = lexist
      nn = nparse
C ... Case fewer values read than sought
      if ( nparse < nminl ) then
C       No error, if defaults are available to fill nparse+1 ... nmin
        if (nndef .ge. nminl .and. (sw.eq.0.or.lexist) .and.
     .  .not. lrqdn) then
          nn = nndef
          ddat(nparse+1:nn) = defa(nparse+1:nn)
C       No error if token's presence not required
        elseif ((sw.eq.0 .or. lor) .and. .not. lexist) then
          continue
C       Otherwise, error exit
        else
          if (.not. lexist) then
            sout = ' gtv (abort): no token '//trim(name)//' found'
          elseif (nminl .eq. 1) then
            sout = ' gtv (abort): no expression read for token '//name
          else
            call info(0,0,0,' gtv: parsed %i%-1j elements: %n:1g',nn,
     .      ddat)
            write(opts(1),"(i4)") nn
            write(opts(2),"(i4)") nminl
            sout = ' gtv (abort): only '// trim(adjustl(opts(1))) //
     .      ' expressions(s) read for ' // name //
     .      ' when ' // trim(adjustl(opts(2))) // ' required'
          endif
          call rx(sout)
        endif
      elseif ( nndef > nminl .and. nparse < nndef ) then
        nn = nndef
        ddat(nparse+1:nn) = defa(nparse+1:nn)
      endif

C ... Copy result to one of (dat,idat,datv,idatv,lg)
      if (present(nout)) nout = nn
      if (ig=='r8' .and. nn==1)      then ;   dat  = ddat(1)
      elseif (lgx .and. nn==1)       then ;   lg = nint(ddat(1)) .ne. 0
      elseif (ig=='i4' .and. nn==1)  then ;   idat = ddat(1)
      elseif (ig=='r8v' .and. nn.gt.0) then ; datv(1:nn)  = ddat(1:nn)
      elseif (ig=='i4v' .and. nn.gt.0) then ; idatv(1:nn) = ddat(1:nn)
      endif

C ... Printout
      if (io_show>0 .or. debug) then
        if (.not. lexist .and. nndef .eq. 0) then
          write(sout(1+len_trim(sout):),"(',   *, --')")
        elseif (nn .eq. nparse .and. nndef .ne. 0) then
          write(sout(1+len_trim(sout):),"(',',i4,',',i3)")nparse,nn-nparse
        elseif (nn .eq. nparse) then
          write(sout(1+len_trim(sout):),"(',',i4,', --')") nparse
        elseif (.not. lexist) then
          write(sout(1+len_trim(sout):),"(',   *,',i3)") nn-nparse
        else
          write(sout(1+len_trim(sout):),"(',',i4,',',i3)")nparse,nn-nparse
        endif
        if (nn .gt. 0 .and. lgx)
     .  call awrit2('%u%55p%n:1l',sout,len(sout),0,nn,lg)
        if (nn .gt. 0 .and. .not. lgx)
     .  call awrit2('%u%55p%n:1,1;6g',sout,len(sout),0,nn,ddat)
        write(stdo,'(a)') trim(sout)
      endif

 1012 format(a,d13.5)
 2012 format(a,200d13.5)
C      if (debug) then
C        call info(0,0,0,' gtv exit: %i%-1j elements: %n:1g',nn,ddat)
C      endif
      end subroutine

      subroutine getinput_entrance()
C- Find token and read contents (true entry points are below)
C ----------------------------------------------------------------------
Ci Inputs
Ci  name   :Name of token, including parents
Ci  nin    :number of arguments to read from token
Ci         :For character input, nin means the following:
Ci         :Not used if quote marks delimit string ("'" or `"')
Ci         :Otherwise:
Ci         :0  string delimited by token's region.
Ci         :1  start-of-string delimited by first non-blank character in region
Ci         :   end-of-string delimited by first blank after start-of-string.
Ci  cindx2 :used to indicate multiple occurences of a token
Ci         :If cindx2>0, use cindx2-th occurence of token
Ci         :Otherwise, cindx2 should be -1
Ci         :Note: the syntax for delimiting the token's region
Ci         :can be different when cindx2>0; see Remarks in
Ci         :subroutine gtv_entrance above.
Co Outputs
Co dat,datv,idat,idatv,char: are all the second argument of the
Co         :generic entry point getinput.  They differ in their cast.
Co         :Only one is used.  Input is stored into this argument.
Co  Texist :.true. if the token could be matched; otherwise .false.
Co Outputs (optional)
Co   nout  :number of elements actually read
Co         :For character input,
Co         :nout is 0 if no nonblank string found
Co         :nout is 1 if a nonblank string is found
Cl Local variables
Cl         :
Cr Remarks
Cr
Cu Updates
Cu   10 Aug 07
C ----------------------------------------------------------------------
      implicit none
C ... Passed parameters
      integer,intent(in) :: nin, cindx2
      character(*),intent(in) :: name
      character(*),intent(out):: char
      real(8),intent(out) :: dat,  datv(1:)
      integer,intent(out) :: idat, idatv(1:)
      integer,optional,intent(out) :: nout
      logical,intent(out) :: Texist
C ... Local parameters
      character(1024) :: nameb
ckino del spoint
      integer :: i1,iend,i,ilev,iix,iex,itrm,
     .mxlev,ie,ii0,ii
ckino      external :: spoint
      integer ::  n
      character(3) :: ig
      character(1) :: keye
      character(5) :: head="@CAT@"
      integer iarr(1000)
      real(8) :: arr(1000)

      character(50),save:: tokencut(10)
      integer a2vec

      entry getinput_r8 (name,  dat,nin,cindx2,Texist,nout)
      ig = 'r8' ;  goto 990
      entry getinput_r8v(name, datv,nin,cindx2,Texist,nout)
      ig = 'r8v' ; goto 990
      entry getinput_i4 (name, idat,nin,cindx2,Texist,nout)
      ig = 'i4' ;  goto 990
      entry getinput_i4v(name,idatv,nin,cindx2,Texist,nout)
      ig = 'i4v';  goto 990
      entry getinput_char(name,char,nin,cindx2,Texist,nout)
      ig = 'chr'; goto 990
      entry getinput_none(name,cindx2,Texist,nout)
      ig = '---'; goto 990

C --- Start of statements common to all entry routines ---
  990 continue

C --- Split token=string1[_string2[_string3...]]; -> tokencut(1..mxlev) ---
      ilev = 0
      nameb = name
      mxlev = 0
      do  !token cut by '_'
        ilev=ilev+1
        iend  = index(nameb,'_') - 1
        if (iend == -1) then
          iend = len_trim(nameb) + 1
          mxlev = ilev
        endif
        if (ilev/=1) tokencut(ilev) = adjustl(nameb(1:iend))
        if (ilev==1) tokencut(ilev) = head//adjustl( nameb(1:iend) )
        nameb = nameb(iend+2:)
        if (mxlev/=0) exit
      enddo
      if (debug)
     .write(stdo,"(10a)") ' getinput: ',name,' partitioned into: ',
     .(trim(tokencut(i))//'->',i=1,mxlev-1), trim(tokencut(mxlev))

C --- Find region of token's contents ---
C     Start from top-level token in tree structure to define
C     region of that level.  A region of a level must be contained
C     in the region of the prior level.
      if (present(nout) ) nout = 0

      i1 = 1
      ie = len_trim(rcd)
      do  ilev = 1, mxlev
        itrm = 12
        if (ig .eq. 'chr') itrm = itrm+100
        if (debug) call pshpr(111)
C       Categories: Terminator=' '  eor=head
        if (ilev .eq. 1) then
          call find_region(ilev,rcd(i1:ie),trim(tokencut(ilev)),' ',
     .    ' ',1,itrm,head,iix,iex)
        elseif (ilev .eq. 2 .and. cindx2 .gt. 0) then
          call find_region(ilev,rcd(i1:ie),trim(tokencut(ilev)),' ',
     .    ':=',cindx2,1000+itrm,trim(tokencut(ilev)),iix,iex)
C       If below highest nesting level, terminator '[' is required
        elseif (ilev .lt. mxlev) then
          call find_region(ilev,rcd(i1:ie),trim(tokencut(ilev)),' ',
     .    ' ',1,1011,head,iix,iex)
C       All other tokens: eor=head and Terminator=':='
        else
          call find_region(ilev,rcd(i1:ie),trim(tokencut(ilev)),' ',
     .    ':=',1,1000+itrm,head,iix,iex)
        endif
        if (debug) call poppr
C       Error exit if token//'[' found has no matching ']'
        if (iix .eq. -99997) call rx('getinput: token '//
     .  trim(tokencut(ilev))//'[ missing its corresponding '']''')
C       Exit if token not found
        if (iix .lt. -99990) then
          if (present(nout) ) nout = 0
          Texist = .false.
          return
        endif
C       Narrow region rcd(i1:ie)
        ii0 = i1
        i1 = ii0-1 + iix
        ie = ii0-1 + iex
      enddo
      Texist = .true.

C --- Token has no arguments ---
      if ( ig == '---' ) then
        if (debug) call info0(0,0,0,
     .  ' getinput: found token '//trim(name))
        return
      endif

C --- Character input ---
      if ( ig == 'chr' ) then
        if (len(char) .eq. 0) then        ! Input string of null length
          if (present(nout) ) nout = 0
        elseif (ie .lt. i1) then          ! Token region of null length
          char = ' '
          if (present(nout) ) nout = 0
C   ... Normal case: fix delimiters
        else
          if (present(nout) ) nout = 1
          if (rcd(i1:i1) .eq. '''') then    ! string delimited by '...'
            ii = index(rcd(i1+1:),'''')
            if (ii .gt. 0) then
              char = rcd(i1+1:i1+ii-1)
            else
              char = rcd(i1+1:ie)
            endif
          elseif (rcd(i1:i1) .eq. '"') then ! string delimited by "..."
            ii = index(rcd(i1+1:),'"')
            if (ii .gt. 0) then
              char = rcd(i1+1:i1+ii-1)
            else
              char = rcd(i1+1:ie)
            endif
C     ... String may be further delimited, depending on nin
          else
            if (nin .eq. 1) then   ! reduce the range of i1:ie
              if (rcd(i1:i1) .eq. ' ') then  ! Shift i1 to 1st nonblank
                keye = adjustl(rcd(i1:ie))
                n = index(rcd(i1:ie),keye)
                if (n .gt. 0) i1 = i1 + n-1
              endif
              n = index(rcd(i1:ie),' ')
              if (n .gt. 0) ie = i1 + n-1
            elseif (nin .gt. 1) then
              call rxi('getinput: illegal value, nin=',nin)
            endif
            char = rcd(i1:ie)
          endif
        endif
        return
      endif

C --- ASCII-numerical conversion ---
      ii = 0
      n = a2vec(rcd(i1:ie),ie-i1+1,ii,4,', ',2,-3,nin,iarr,arr)
      if (n .lt. 0) n = -n-1
      if (debug) call info(0,0,0,
     .' getinput: sought %i numbers, read %i from '//trim(name),
     .nin,n)

      if (present(nout) ) nout = n
C --- Copy array to data ---
      if (n .eq. 0) then;
      elseif (ig=='r8')  then ;   dat = arr(1)
      elseif (ig=='i4')  then ;   idat = arr(1)
      elseif (ig=='r8v') then;  datv(1:n) = arr(1:n)
      elseif (ig=='i4v') then;  idatv(1:n) = arr(1:n)
      endif
      end subroutine getinput_entrance

      end module
