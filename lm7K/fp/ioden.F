#define USEOPTIONAL

      module m_ioden2
      contains
      subroutine ioden2(mode,sopts,nsp,plat,alat,nbas,pos,z,k1,k2,k3,
     .ngabc,smrho,wk,nwk,modrhg)

C- Kernel called by ioden
C ----------------------------------------------------------------------
Ci Inputs
Ci   mode  :0 just return these arguments parsed from sopts:
Ci         :  modrhg
Ci         :1 copy and save density in appropriate plane
Ci   sopts :string containing options; see ioden above.
Ci   plat  :primitive lattice vectors, in units of alat (for printout)
Ci   alat  :lattice constant
Ci   nbas  :number of atoms in unit cell
Ci   pos   :atomic positions in unit cell
Ci   z     : atomic number of atoms in cell
Ci   nsp   :number of spin channels
Ci   k1..3 :dimensions smrho
Ci   ngabc :number of divisions in smrho along plat(1..3)
Ci   smrho :smooth density on uniform mesh
Ci   wk    :2D work array
Ci   nwk   :dimensions wk
Co Outputs
Co   modrhg:controls what part of core density is added
Co   The projection of smrho onto a plane is written to disk
Co   or if option is g3d the full 3d grid is written to disk
Cl Local variables
Cl   lic   :lic(1..3,1..2) = step length in each vector axes 1..2
Cl         :lic(4,1..2)    = number of points along axes 1..2
Cl         :lic(5..7,1)    = starting element for each lattice vector
Cr Remarks
Cr   Choosing p1, p2, p3 sets the origin for that plat and also
Cr   creates a default set of vectors, choosing the other lattice
Cr   vectors in the system.  Thus:
Cr   p1=# => lic(1..7,1) = (0 1 0 nb 1 1 1) lic(1..7,2) = (0 0 1 nc **)
Cr   p2=# => lic(1..7,1) = (0 0 1 nc 1 1 1) lic(1..7,2) = (1 0 0 na **)
Cr   p3=# => lic(1..7,1) = (1 0 0 na 1 1 1) lic(1..7,2) = (0 1 0 nb **)
Cu Updates
Cu   09 Feb 01 Revised how a plane is defined.
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      character*(*) sopts
      integer mode,ngabc(3),k1,k2,k3,nwk,nsp,modrhg,nbas
#ifdef USEOPTIONAL
      double complex ,optional:: smrho(k1,k2,k3,nsp)
      double precision plat(3,3),alat,pos(3,nbas)
      real(8),optional:: wk(nwk,nwk,nsp)
#else
      double complex smrho(k1,k2,k3,nsp)
      double precision plat(3,3),wk(nwk,nwk,nsp),alat,pos(3,nbas)
#endif
      double precision z(nbas)
C ... Local parameters
      logical lok
      integer lgunit,stdo,j2,j1,fopn,ifi,i
      integer lic(7,2),j,k,iv(3),jv(3),kv(4),a2vec,isp
      double precision vecs(3,2),vv,ddot
      character*120 dc*1, fn, prfmt*40, sout
      logical lg3d
      integer i1,i2,i3

      logical:: l_dummy_isanrg,isanrg

ccccccccccccccccccccccccccccc
c      print *,' zzxxx=',z
c      stop 'zzzzzzzzzzzzzzzzzzzzzzzzzzzz'
ccccccccccccccccccccccccccccc

      stdo = lgunit(1)
      dc = sopts(1:1)
      fn = 'smrho'
C     prfmt = '(8f10.6)'
      prfmt = '(8e14.6)'
      lg3d = .false.
C     Default: origin at (1,1,1), (na+1,nb+1) points along 1st,2nd axes
      call iinit(lic,14)
      call ivset(lic,5,7,1)
      lic(1,1) = 1
      lic(4,1) = ngabc(1)+1
      lic(2,2) = 1
      lic(4,2) = ngabc(2)+1

      if (dc .ne. ' ') then
C ... Return here to resume parsing for arguments
        j2 = 0
   10   continue
        j2 = j2+1
        if (sopts(j2:j2) .eq. dc) goto 10
        j1 = min(len(sopts),j2)
        call nwordg(sopts,0,dc//' ',1,j1,j2)
        if (j2 .ge. j1) then
          if (.false.) then
          elseif (sopts(j1:j1+2) .eq. 'fn=')  then
            if (j1+3 .gt. j2) goto 99
            fn = sopts(j1+3:j2)
C   ... option g3d
          elseif (sopts(j1:j1+2).eq. 'g3d') then
            lg3d = .true.
C   ... option o=#,#,#
          elseif (sopts(j1:j1+1) .eq. 'o=')  then
            if (j1+2 .gt. j2) goto 99
            i = j1+1
            if (a2vec(sopts,j2,i,2,', '//dc,3,2,3,kv,iv) .ne. 3)
     .      goto 99
            lic(5,1) = mod(iv(1)+ngabc(1),ngabc(1))+1
            lic(6,1) = mod(iv(2)+ngabc(2),ngabc(2))+1
            lic(7,1) = mod(iv(3)+ngabc(3),ngabc(3))+1
C   ... option l[12]=#,#,#,#
          elseif (sopts(j1:j1+2) .eq. 'l1=' .or.
     .    sopts(j1:j1+2) .eq. 'l2=')  then
            if (j1+3 .gt. j2) goto 99
            i = 0
            call chrps2(sopts(j1+1:),'12',2,0,i,iv)
C         this check should never be necessary
Ckino isanrg is logical function, C         call isanrg(iv,1,2,' ','iv in ioden ... bug ..',.true.)
C         l_dummy_isanrg=isanrg(iv,1,2,' ','iv in ioden ... bug ..',.true.)
            i = j1+2
            j = iv(1)
            k = a2vec(sopts,j2,i,2,', '//dc,3,2,4,kv,lic(1,j))
            if (k .ne. 3 .and. k .ne. 4) goto 99
          elseif (sopts(j1:j1+4) .eq. 'core=') then
            if (j1+5 .gt. j2) goto 99
            i = j1+4
            if (a2vec(sopts,j2,i,2,' '//dc,2,1,1,kv,modrhg) .ne. 1)
     .      goto 99
          else
            call rxs('ioden: unrecognised option ... ',sopts(j1:j2))
          endif
          goto 10
        endif
      endif
      if (mode .eq. 0) return

C --- Printout ---
      if (lg3d) then
        ifi = fopn(fn)
        rewind ifi
        call awrit3('      Writing smooth density to file'//fn//
     .  ' %a : full 3d grid (%i,%i,%i).',' ',80,stdo,k1,k2,k3)
        do isp = 1, nsp
C           call awrit4('%% 3D block data %i %i %i, spin=%i',' ',80,ifi,
C     .     k1,k2,k3,isp)
          write(ifi,'("CRYSTAL")')
          write(ifi,'("PRIMVEC")')
          write(ifi,'(3f10.5)') ((plat(i1,i2)*alat*0.529177208,i1=1,3)
     .    ,i2=1,3)
          write(ifi,'("PRIMCOORD")')
          write(ifi,'(2i5)') nbas,1
          do i = 1, nbas
            write(ifi,'(i4,2x,3f10.5)') int(z(i)),
     .      (pos(i2,i)*alat*0.529177208,i2=1,3)
          enddo
          write(ifi,'("BEGIN_BLOCK_DATAGRID_3D")')
          write(ifi,'("charge_density_spin_",i1)') isp
          write(ifi,'("BEGIN_DATAGRID_3D_isp_",i1)') isp
          write(ifi,'(3i4)') k1,k2,k3
          write(ifi,'(3f10.5)') 0.,0.,0.
          write(ifi,'(3f10.5)') ((plat(i1,i2)*alat*0.529177208,i1=1,3)
     .    ,i2=1,3)
          write(ifi,'(8e14.6)')  
     .    (((dble(smrho(i1,i2,i3,isp)),i1=1,k1),i2=1,k2),i3=1,k3)
          write(ifi,'("END_DATAGRID_3D_isp_",i1)') isp
          write(ifi,'("END_BLOCK_DATAGRID_3D")')
        enddo
        call fclose(ifi)
        return
      else
        call awrit3('         Writing smooth density to file '//fn//
     .  '%a : origin at (%i,%i,%i).',' ',80,stdo,lic(5,1)-1,
     .  lic(6,1)-1,lic(7,1)-1)
        call dpzero(vecs,3)
        do  i = 1, 3
          call daxpy(3,dble(lic(4+i,1)-1)/ngabc(i),plat(1,i),1,vecs,1)
        enddo
        call ivset(kv,1,3,2)
        call shorps(1,plat,kv,vecs,vecs)
        write(stdo,368) (vecs(i,1), i=1,3)
  368   format(9x,'In cartesian coordinates, origin is',3f10.6)

        call dpzero(vecs,6)
        do  k = 1, 2
          do  i = 1, 3
            vv = dble((lic(4,k)-1)*lic(i,k))/dble(ngabc(i))
            call dpadd(vecs(1,k),plat(1,i),1,3,vv)
          enddo
          vv = dsqrt(ddot(3,vecs(1,k),1,vecs(1,k),1))
          sout = ' '
          call awrit8('%9fv%i: (%i pts) = (%i,%i,%i)p -> '//
     .    '(%,6;6d,%,6;6d,%,6;6d)',sout,80,0,k,lic(4,k),
     .    lic(1,k),lic(2,k),lic(3,k),vecs(1,k),vecs(2,k),vecs(3,k))
          call awrit1('%a l=%,6;6d',sout,-80,-stdo,vv)
        enddo

C ... Sanity checks
        lok = .true.
        lok = lok .and. lic(4,1) .gt. 0
        lok = lok .and. lic(4,2) .gt. 0
        if (.not. lok) call fexit2(-1,1,' Exit -1 ioden: number of '//
     .  'points along axes (%i,%i) are not > 0',lic(4,1),lic(4,2))
        if (nwk.lt.lic(4,1) .or. nwk.lt.lic(4,2)) call rx('increase nwk')

C --- Copy points to wk from plane ---
        call icopy(3,lic(5,1),1,kv,1)
        do  k = 1, lic(4,2)
          call icopy(3,kv,1,iv,1)
C         PRINT *, K, KV(1), KV(2), KV(3)
          do  i = 1, lic(4,1)
C         PRINT *, ' ',I, IV(1), IV(2), IV(3)
            do  j = 1, 3
              jv(j) = mod(iv(j)-1,ngabc(j))+1
   44         if (jv(j) .le. 0) then
                jv(j) = jv(j) + ngabc(j)
                goto 44
              endif
            enddo
            if (jv(1) .le. 0 .or. jv(2) .le. 0 .or. jv(3) .lt. 0) then
              call rx('bug in ioden')
            endif
            do  isp = 1, nsp
              wk(i,k,isp) = dble(smrho(jv(1),jv(2),jv(3),isp))
            enddo
C          if (i .eq. 1 .or. i .eq. 16) then
C          PRINT *, I,K, JV(1), JV(2), JV(3),WK(I,K)
C          endif
            do  j = 1, 3
              iv(j) = iv(j) + lic(j,1)
            enddo
          enddo
          do  j = 1, 3
            kv(j) = kv(j) + lic(j,2)
          enddo
        enddo

C --- Write the file ---
        ifi = fopn(fn)
        rewind ifi
        do  isp = 1, nsp
          call ywrm(0,' spin 1',1,ifi,prfmt,wk(1,1,isp),0,nwk,lic(4,1),
     .    lic(4,2))
        enddo
        call fclose(ifi)
        return
      endif

   99 continue
      call rxs('ioden: failed to parse option ... ',sopts(j1:j2))

      end subroutine ioden2
      end module m_ioden2

      subroutine ioden ( sopts , slat , ssite , sspec , sv_p_orhat 
     . , smrho )


      use m_struc_def  !Cgetarg
      use m_globalvariables
      use m_ioden2
C- File I/O charge density on a uniform mesh in a plane or full 3d mesh
C ----------------------------------------------------------------------
Ci Inputs
Ci   sopts :character string specifying plane and other options.
Ci         :Specifications and options are separated by a delimiter,
Ci         :which is the first character in sopts.
Ci         :
Ci         :if option is g3d then the density is written to
Ci         :disk on the full 3d grid.   Otherwise:
Ci         :The density is written to disk for a uniform of mesh of
Ci         :points in one plane.  This information is specified by three
Ci         :groups of numbers: the origin, a first direction vector with
Ci         :its number of points, and a second direction vector with its
Ci         :number of points.
Ci         :
Ci         :At present, these points must be taken from the points on
Ci         :the smooth mesh, smrho.  In this case, all three groups of
Ci         :information are sets of integers.  For example,
Ci         :specify the origin by three numbers:
Ci         :    o=#1,#2,#3
Ci         :The point (#1,#2,#3) corresponds to the Cartesian coordinate
Ci         :   #1/n1 p1 + #2/n2 p2 + #3/n3 p3
Ci         :where (n1,n2,n3) are the number of divisions in the
Ci         :mesh along the three lattice vectors (p1,p2,p3).
Ci         :o=0,0,0 corresponds to the origin.
Ci         :
Ci         :Specify the direction vectors by
Ci         :    l1=#1,#2,#3[,#4]
Ci         :    l2=#1,#2,#3[,#4]
Ci         :
Ci         :l1 and l2 specify the first and second direction vectors,
Ci         :respectively.  #1,#2,#3 select the
Ci         :increments in mesh points along each of the three lattice
Ci         :vectors that define the direction vector.  Thus in Cartesian
Ci         :coordinates a direction vector is
Ci         :   #1/n1 p1 + #2/n2 p2 + #3/n3 p3
Ci         :where as before (n1,n2,n3) are the number of divisions in
Ci         :the mesh along the three lattice vectors (p1,p2,p3).
Ci         :The last number (#4) specifies how many points to take
Ci         :in that direction.
Ci         :
Ci         :Other options:
Ci         :  g3d       output of 3d grid plus headers in xsf format ready for xcrysden
Ci         :  fn=name   specifies the file name for file I/O
Ci         :
Ci         :   core=#   specifies how local rho is to be included
Ci         :            #=0 include core densities - nuclear charge
Ci         :            #=1 include core densities
Ci         :            #=2 (default) exclude core densities
Ci         :            #=-1 no local densities to be included
Ci         :            #=-2 true local density, no smoothed part
Ci         :            #=-3 istl-local sm densities, no true part
Ci         :
Ci         :Example: using '~' as the delimiter, and suppose
Ci         :n1=n2=48 and n3=120, the specification
Ci         :  ~fn=myrho~o=0,0,60~l1=1,1,0,49~l2=0,0,1,121
Ci         :writes 'myrho.ext' a mesh (49,121) points.
Ci         :The origin (first point) lies at (p3/2)
Ci         :The first vector points along (p1+p2), and has that length;
Ci         :the second vector points along p3, and has that length.
Ci   slat  :struct for lattice information; see routine ulat
Ci     Elts read: plat nabc ng okv vol
Ci     Stored:    *
Ci     Passed to: rhgcmp
Ci   ssite :struct for site-specific information; see routine usite
Ci     Elts read: *
Ci     Stored:    *
Ci     Passed to: rhgcmp
Ci   sspec :struct for species-specific information; see routine uspec
Ci     Elts read: *
Ci     Stored:    *
Ci     Passed to: rhgcmp
Ci   orhat :offsets to arrays containing local atom densities
Ci   smrho :smooth density on uniform mesh
Co Outputs
Co   The sum local gaussian densities and smrho is written to disk
Cl Local variables
Cl   modrhg:controls what part of core density is added
Cl         :-1 Add no local densities
Cl         : 0 include core density - sm nuclear charge
Cl         : 1 include core density, but no nuclear charge
Cl         : 2 exclude core density
Cr Remarks
Cr    sopts specifies which plane(s) are written to disk
Cr Bugs
Cr   Routines create smoothe approximation to density, not true density
Cu Updates
Cu   July 7 05 (Walter Lambrecht) New option g3d
Cu   25 Aug 04 New modes -2, -3
Cu   24 May 03 Corrections to errors in messages
Cu   23 Oct 01 Local densities are more accurately represented
Cu             in G_kL expansion:  k=0..kmax.  Added core= option.
Cu   25 Apr 01 Simplified the plane specification
Cu   02 Mar 01 Spin polarized
Cu   09 Feb 01 Added local gaussian densities to file I/O
Cu             and extended how a plane may be specified
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      character*(*) sopts
      type(s_lat)::slat
      type(s_site)::ssite(*)
      type(s_spec)::sspec(*)

      type(s_rv1) :: sv_p_orhat

      double complex smrho(*)
C ... Local parameters
      integer ngabc(3),n1,n2,n3,k1,k2,k3,kmax
      integer kkk,lgunit,ng,nglob,nsp,nwk,stdo,modrhg,nbas,i
ckino Dec.9.2011:          real(8),pointer :: rv_p_opos(:) =>NULL()

ckino Dec.9.2011:         integer,pointer :: iv_p_okv(:) =>NULL()

      complex(8) ,allocatable :: cn_zv(:)
      complex(8) ,allocatable :: psrho_zv(:)
ckino not complex but real      complex(8) ,allocatable :: wk_zv(:)
      real(8) ,allocatable :: wk_rv(:)

      equivalence (n1,ngabc(1)),(n2,ngabc(2)),(n3,ngabc(3))
      double precision vol,xx0,xx,dval,plat(3,3),alat
      integer ib,is,igetss
C ... Heap
      integer ::iwdummy

      logical:: l_dummy_isanrg,isanrg

C ... External calls
ckino del upack,upack2
      external awrit2,dcopy,fclose,fftz3,fftz30,gvgetf,
     .gvputf,icopy,ivset,mkils0,mkilst,nwordg,poppr,
     .pshpr,rhgcmp,rhomom,rx

      real(8),allocatable:: zz(:)
C ... Unpack and setup
Changenglob      nsp = nglob('nsp')
      nsp = globalvariables%nsp
Changenglob      nbas = nglob('nbas')
      nbas = globalvariables%nbas
      stdo = lgunit(1)

      i_copy_size=size(slat%plat)
      call dcopy(i_copy_size,slat%plat,1,plat,1)
      i_copy_size=size(slat%nabc)
      call i8icopy(i_copy_size,slat%nabc,1,ngabc,1)
      ng=slat%ng
ckino Dec.9.2011:         iv_p_okv => slat%iv_p_okv

      vol=slat%vol

ccccccccccccccccccccccccccccc
c      allocate(zz(nbas))
c      zz=sspec(1:nbas)%z
c      print *,' zz1=',zz
c      print *,' zz2=',sspec(1:nbas)%z
c      stop 'zzzzzzzzzzzzzzzzzzzzzzzzzzzz'
ccccccccccccccccccccccccccccc


      alat=slat%alat
ckino Dec.9.2011:         rv_p_opos => slat%rv_p_opos


c      call defrr(oz,nbas)
c      do ib = 1,nbas
c        is = int(ssite(ib)%spec)
cc        w(oz-2+ib*2)=sspec(is)%z !but Kino's email on 5June2010.
c        call dcopy(1,sspec(is)%z,1,w(oz-2+ib*2),1)
c      enddo
      call fftz30(n1,n2,n3,k1,k2,k3)
      kkk = k1*k2*k3
      kmax = 3
      modrhg = 2
c      call ioden2(0,sopts,nsp,plat,alat,nbas,w(opos),w(oz),k1,k2,k3,
c     .ngabc,w,w,nwk,modrhg)
Ckino  mode=0 checks format
#ifdef USEOPTIONAL
      call ioden2 ( mode=0 , sopts=sopts ,nsp= nsp ,plat= plat ,
ckino Dec.9.2011:       .   alat=alat , nbas=nbas , pos=rv_p_opos
ckino Jan.04.2012:       .   alat=alat , nbas=nbas , pos=slat%rv_p_opos 
     .   alat=alat , nbas=nbas , pos=slat%rv_a_opos 
     .  , z=sspec ( ssite ( 1:nbas ) %spec ) %z , k1=k1 , k2=k2 , k3=k3
     .   , ngabc=ngabc 
     .  , nwk=nwk , modrhg=modrhg )
#else
ckino Dec.9.2011:          call ioden2 ( 0 , sopts , nsp , plat , alat , nbas , rv_p_opos
ckino Jan.04.2012:          call ioden2 ( 0 , sopts , nsp , plat , alat , nbas , slat%rv_p_opos
      call ioden2 ( 0 , sopts , nsp , plat , alat , nbas , slat%rv_a_opos 
     .  , sspec ( ssite ( 1:nbas ) %spec ) %z , k1 , k2 , k3 , ngabc 
     .  , iwdummy , iwdummy , nwk , modrhg )
#endif


Ckino isanrg is logical function,       call isanrg(modrhg,-3,2,'ioden','core option',.true.)
      l_dummy_isanrg=isanrg(modrhg,-3,2,'ioden','core option',.true.)

C ... Overwrite smrho+, smrho- with smrho, smrho+ - smrho-
Ckino  smrho is complex(8), dsumdf() is for real(8)
Ckino  so kkk*2 is necessary to use dsumdf().
Ckino
Ckino  return values: smrho(:kkk)=spin(1)+spin(2)
Ckino  and            smrho(kkk+1:kkk*2)=spin(1)-spin(2)
      if (nsp .eq. 2) then
        call dsumdf(kkk*2,1d0,smrho,0,1,smrho(1+kkk),0,1)
      endif

C ... Put n0(G) into psrho and cn
      allocate(psrho_zv(kkk*nsp))

      allocate(cn_zv(ng*nsp))

Ckino smrho is complex(8) , so kkk*2 is necessary.
      call dcopy ( kkk * 2 * nsp , smrho , 1 , psrho_zv , 1 )

      call fftz3 ( psrho_zv , n1 , n2 , n3 , k1 , k2 , k3 , nsp 
     ., 0 , - 1 )

ckino Dec.9.2011:         call gvgetf ( ng , nsp , iv_p_okv , k1 , k2 , k3 , psrho_zv ,
ckino Dec.28.2011:         call gvgetf ( ng , nsp , slat%iv_p_okv , k1 , k2 , k3 , psrho_zv ,
      call gvgetf ( ng , nsp , slat%iv_a_okv , k1 , k2 , k3 , psrho_zv , 
     . cn_zv )
Ckino now cn_zv(G,nsp)


Ckino xx0 = real and G=0 component
      xx0 = dval ( cn_zv , 1 )


C ... Add sum of local gaussian densities to mesh density
      print *,' modrhg=',modrhg
Ckino core=#   specifies how local rho is to be included
Ckino         :            #=0 include core densities - nuclear charge
Ckino         :            #=1 include core densities
Ckino         :            #=2 (default) exclude core densities
Ckino         :            #=-1 no local densities to be included
Ckino         :            #=-2 true local density, no smoothed part
Ckino         :            #=-3 istl-local sm densities, no true part
      if (modrhg .ge. 0 .or. modrhg .le. -2) then
        if (modrhg .eq.  0) i = 131
        if (modrhg .eq.  1) i =  31
        if (modrhg .eq.  2) i =   1
        if (modrhg .eq. -2) i =   2
        if (modrhg .eq. -3) i =   3
        if ( i .eq. 2 ) call dscal ( ng * nsp * 2 , 0d0 , cn_zv , 
     .  1 )
Ckino                      -> cn_zv=0 if i==2

        if ( i .eq. 3 ) call dscal ( ng * nsp * 2 , - 1d0 , cn_zv 
     .  , 1 )
Ckino                      -> cn_zv=-cn_zv if i==3

        call rhgcmp ( i , 1 , nbas , ssite , sspec , slat , sv_p_orhat 
     .   , kmax , ng , cn_zv )


        if ( i .eq. 3 ) call dscal ( ng * nsp * 2 , - 1d0 , cn_zv 
     .  , 1 )

      endif
      xx = dval ( cn_zv , 1 )


C ... FFT (n0 + gaussians) (G) to real-space mesh
      if (modrhg .ge. 0) then
ckino Dec.9.2011:           call gvputf ( ng , nsp , iv_p_okv , k1 , k2 , k3 , cn_zv , psrho_zv
ckino Dec.28.2011:           call gvputf ( ng , nsp , slat%iv_p_okv , k1 , k2 , k3 , cn_zv , psrho_zv
        call gvputf ( ng , nsp , slat%iv_a_okv , k1 , k2 , k3 , cn_zv , psrho_zv 
     .   )


        call awrit2('%N ioden : local densities + envelope density,'
     .  //' Qloc=%,6;6d  Q=%,6;6d',' ',80,stdo,(xx-xx0)*vol,xx*vol)
        if (modrhg .lt. 2) then
          call awrit1('%9fLocal densities include core'//
     .    '%?#n==0#+nuclear## contributions.',' ',80,stdo,modrhg)
        endif
      elseif (modrhg .eq. -2) then
        call info2(0,0,0,'%N ioden : local'//
     .  ' densities (true-smooth terms),  Qloc=%,6;6d',xx*vol,0)
      elseif (modrhg .eq. -3) then
        call info2(0,0,0,'%N ioden : smooth (envelope - local)'//
     .  ' density,  Qs=%,6;6d  Qs-Qs(loc)=%,6;6d',
     .  xx0*vol,xx*vol)
      else
        call info2(0,0,0,'%N ioden : smooth density only'//
     .  ' (no local densities added) Qsm=%,6;6d',xx0*vol,0)
      endif

      call fftz3 ( psrho_zv , n1 , n2 , n3 , k1 , k2 , k3 , nsp 
     ., 0 , 1 )
Ckino now psrho_zv is real space mesh.


      if (allocated(cn_zv)) deallocate(cn_zv)


C ... File I/O
      nwk = 12*max(k1,k2,k3)

ckino not complex but real,      allocate(wk_zv(nwk**2*nsp))
      allocate(wk_rv(nwk**2*nsp))

Ckino mode=1 write smrho to the file
ckino Dec.9.2011:         call ioden2 ( 1 , sopts , nsp , plat , alat , nbas , rv_p_opos
ckino Jan.04.2012:         call ioden2 ( 1 , sopts , nsp , plat , alat , nbas , slat%rv_p_opos
      call ioden2 ( 1 , sopts , nsp , plat , alat , nbas , slat%rv_a_opos 
     . , sspec ( ssite ( 1:nbas ) %spec ) %z , k1 , k2 , k3 , ngabc
ckino not complex but real     . , psrho_zv , wk_zv , nwk , modrhg ) 
     . , psrho_zv , wk_rv , nwk , modrhg )


ckino not complex but real      if (allocated(wk_zv)) deallocate(wk_zv)
      if (allocated(wk_rv)) deallocate(wk_rv)
      if (allocated(psrho_zv)) deallocate(psrho_zv)

c      call rlse(oz)


C ... Restore smrho+, smrho-
      if (nsp .eq. 2) then
        call dsumdf(kkk*2,.5d0,smrho,0,1,smrho(1+kkk),0,1)
      endif
      end subroutine ioden




