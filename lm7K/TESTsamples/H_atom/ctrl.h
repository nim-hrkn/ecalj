### Do lmf --input to see all effective category and token ###
### It will be not so difficult to edit ctrlge.py for your purpose ###
VERS    LM=7 FP=7
             # version check. Fixed.
IO      SHOW=T VERBOS=35
             # SHOW=T shows readin data (and default setting at the begining of console output)
	     # It is useful to check ctrl is read in correctly or not (equivalent with --show option).
	     #
	     # lerger VERBOSE gives more detailed console output.
SYMGRP find  # 'find' evaluate space-group symmetry automatically.
             # Usually 'find is OK', but lmf may use lower symmetry
	     # because of numerical problem.
             # Do lmchk to check how it is evaluated.
%const kmxa=7  # kmxa=7 is good for pwemax=5 or lower.
               # larger kmxa is better but time-consuming (maybe not the critical part for large systems).
STRUC   ALAT=15  PLAT= 1 0 0 0 1 0 0 0 1
  NBAS= 1  NSPEC=1
SITE    ATOM=H POS= 0 0 0
SPEC
 ATOM= H Z= 1 R=2
      RSMH= 1.293  EH= -0.335
      KMXA={kmxa} LMXA=4
      MMOM=1 0 0


% const pwemax=3 nk=1
BZ    NKABC={nk} {nk} {nk}  # division of BZ for q points.
      METAL=3   # METAL=3 is safe setting. For insulator, METAL=0 is good enough.
		# When you plot dos, set SAVDOS=T and METAL=3, and with DOS=-1 1 (range) NPTS=2001 (division) even for insulator.
		#   (SAVDOS, DOS, NPTS gives no side effect for self-consitency calculaiton).
      BZJOB=0	# BZJOB=0 (including Gamma point) or =1 (not including Gamma point).
		#  In cases , BZJOB=1 makes calculation efficient.

ITER  CONV=1e-6 CONVC=1e-6 NIT=30
                # An other choice is
                # ITER MIX=A2,b=.5,n=3 CONV=1e-6 CONVC=1e-6 NIT=20
                # Practically results are independent from mixing procedure.
		
HAM   NSPIN=2   # Set NSPIN=2 for spin-polarize case; then set SPEC_MMOM (initial guess of magnetic polarization).
      FORCES=0  # 0: no force calculation, 1: forces calculaiton 
      GMAX=6    # this is for real space mesh. See GetStarted.
      REL=T     # T:Scaler relativistic, F:non rela.

      XCFUN=1   # =1 for Vosko-Ceperly-Alder; GGA is not yet.
                # XCFUN=2 shows a bug for Hydrogen atom. 
		# (subs/evxc.F works only for XCFUN=1 if rho(up)=0 or rho(down)=0).

      PWMODE=11 # 10: MTO basis only (LMTO) PW basis is not used.
                # 11: APW+MTO        (PMT)
                # 12: APW basis only (LAPW) MTO basis is not used.

      PWEMAX={pwemax} # (in Ry). When you use larger pwemax more than 5, be careful
                      # about overcompleteness. See GetStarted.
      ELIND=-1  # this is only for accelaration of convergence. Not need to change.
      
OPTIONS PFLOAT=1 # Q=band (this is quit switch if you like to add)
                 # 