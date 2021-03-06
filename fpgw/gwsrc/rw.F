c These routines are taken from Ferdi's rw.f
c-----------------------------------------------------------------
      subroutine readx(ifil,n)
      character*72 rchar
      do 10 i = 1,n
        read(ifil,5000)rchar
        j       = 0
c        call rmvbl (rchar,72,j)
c        rchar      = rchar(j+1:72)
        rchar=trim(adjustl(rchar))

        if(rchar(1:3) .eq. '***')return
        if(rchar(1:3) .eq. '###')return

   10 continue
Cstop2rx 2013.08.09 kino      stop 'readx: cannot find the string(rw.f)'
      call rx( 'readx: cannot find the string(rw.f)')
 5000 format(a72)
c     return
      end
c-------------------------------------------------------------------
      subroutine rwdd (ifi,
     d                 ldim,n,
     o a)

c 92.02.07
c direct access read (ifi>0) or write (ifi<0)

c ldim = leading dimension of a

      implicit real*8  (a-h,o-z)
      dimension a(ldim,n)

Cstop2rx 2013.08.09 kino      if (ifi .eq. 0) stop 'rwdd: ifi .eq. 0'
      if (ifi .eq. 0) call rx( 'rwdd: ifi .eq. 0')

c read
      if (ifi .gt. 0) then
        do       j = 1,n
          read (ifi,rec=j) (a(i,j),i=1,ldim)
        end do
      endif

c write
      if (ifi .lt. 0) then
        do       j = 1,n
          write (-ifi,rec=j) (a(i,j),i=1,ldim)
        end do
      endif

      return
      end
c-------------------------------------------------------------------
      subroutine rwdd1 (ifi,irec,
     d                  ldim,
     o a)

c 92.02.07
c direct access read (ifi>0) or write (ifi<0) for record irec

c irec = record number
c ldim = leading dimension of a

      implicit real*8  (a-h,o-z)
      real*8 a(ldim)

Cstop2rx 2013.08.09 kino      if (ifi .eq. 0) stop 'rwdd1: ifi .eq. 0'
      if (ifi .eq. 0) call rx( 'rwdd1: ifi .eq. 0')

c read
      if (ifi .gt. 0) then
        read (ifi,rec=irec) (a(i),i=1,ldim)
      endif

c write
      if (ifi .lt. 0) then
        write (-ifi,rec=irec) (a(i),i=1,ldim)
      endif

      return
      end

c--------------------------------------------------------------------
      subroutine wkpnt (ifkp,qbz,wbz,nqbz)

c 92.04.21
c write k-points

      implicit real*8 (a-h,o-z)
      dimension qbz(3,nqbz),wbz(nqbz)

Cstop2rx 2013.08.09 kino      if (ifkp .lt. 0) stop 'wkpnt: unit file < 0'
      if (ifkp .lt. 0) call rx( 'wkpnt: unit file < 0')
      write (ifkp,*) ' label  k-vector  weight '
      do       k = 1,nqbz
        write (ifkp,6000)k,(qbz(i,k),i=1,3),wbz(k)
      end do

 6000 format (1x,i4,4f12.6)
      return
      end
