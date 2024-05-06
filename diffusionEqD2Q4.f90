!--------------------------------------------------------------------------------------------------
! 2024/1 Vitória Ufes
! Course: "PFIS2075 Tópicos Física Estatística em Fenômenos de Transporte"
! Prof.: Humberto Belich
! Author: Mário Tristão
!--------------------------------------------------------------------------------------------------
!Solve a Heat Diffusion in an Infinite Slab Subjected to a Constant Temperature
!--------------------------------------------------------------------------------------------------
!Equation:
!	D(T)/D(t) = alpha*[D²(T)/D(x)²] -> PDE
!--------------------------------------------------------------------------------------------------
!Initial Coditions:
!		*Tinit  = 0.0 	(Initial Temp. dimensionless)
!		*Tmax   = 1.0 	(Max Temp. dimensionless)
! 		*Linit  = 0.0 	(Initial Length Size)
!		*Lmax   = 100.0 (Max Length Size)
!		*tsteps = 400   (time steps)
!		*alpha  = 0.25  (coefficient of thermal diffusivity)
!--------------------------------------------------------------------------------------------------
!Boundary Codition:
! 		*Dirichlet for a Adiabatic Function -> T=0
!               y
!   	        ^         T=0.0
!		+---------+---------+
!		+	  +	    +
!		+	  +	    +
!		+         +         +
!		+ T=1.0   +         + T=0.0
!		+         +         +
!      		+         +         +
!		+         +         +
!		+---------+---------+ >x 
!		         T=0.0
!--------------------------------------------------------------------------------------------------
!LBM for a D2Q4 Streaming Steps:
!	
!	       f4
!	       |
!	 F1 ---|--- F2
!	       |
!	      f3
!---------------------------------------------------------------------------------------------------
PROGRAM DIFFD214
 PARAMETER (NX=100,NY=100) !plate size
 REAL F1(0:NX,0:NY),F2(0:NX,0:NY),F3(0:NX,0:NY),F4(0:NX,0:NY) !declaration and range of the populations
 REAL RHO(0:NX,0:NY),FEQ,X(0:NX),Y(0:NY)
 REAL DX, DY, DT
 REAL ALPHA,OMEGA
 INTEGER I,J,KK,MSTEP
 
 open(22,file='output.dat')
 
 DX=1.0
 DY=DX
 DT=1.0
 X(0)=0.0
 Y(0)=0.0
 DO I=1,NX
  X(I)=X(I-1) + DX
 ENDDO
 DO J=1,NY
  Y(J)=Y(J-1)+DY
 ENDDO
 CSQ=DX*DX/(DT*DT)
 ALPHA=0.25
 OMEGA=1.0/(2.*ALPHA/(DT*CSQ)+0.5) !D2Q5 omega=1.0/(3.*ALPHA/(DT*CSQ)+0.5)
 MSTEP=400
 DO J=0,NY
  DO I=0,NX
   RHO(I,J)=0.0
  ENDDO
! initial values of the dependent variable
 ENDDO
 DO J=0,NY
  DO I=0,NX
   F1(I,J)=0.25*RHO(I,J)
   F2(I,J)=0.25*RHO(I,J)
   F3(I,J)=0.25*RHO(I,J)
   f4(I,J)=0.25*RHO(I,J)
!for D2Q5 -> w0=0.332 and w(1,4) = 0.167
  ENDDO
 ENDDO
 !MAIN LOOP
 DO KK=1,MSTEP
  DO J=0,NY
   DO I=0,NX
    FEQ=0.25*RHO(I,J)
    F1(I,J)=OMEGA*FEQ+(1.-OMEGA)*F1(I,J)
    F2(I,J)=OMEGA*FEQ+(1.-OMEGA)*F2(I,J)
    F3(I,J)=OMEGA*FEQ+(1.-OMEGA)*F3(I,J)
    f4(I,J)=OMEGA*FEQ+(1.-OMEGA)*F4(I,J)
   ENDDO
  ENDDO
! Streaming
  DO J=0,NY
   DO I=1,NX
    F1(NX-I,J)=F1(NX-I-1,J)
    F2(I-1,J)=F2(I,J)
   ENDDO
  ENDDO
  DO I=0,NX
   DO J=1,NY
    F3(I,NY-j)=F3(I,NY-J-1)
    F4(I,J-1)=F4(I,J)
   ENDDO
  ENDDO
! Boundary conditions
  DO J=1,NY
   F1(0,J)=0.5-F2(0,J)
   F3(0,J)=0.5-F4(0,J)
   F1(100,J)=0.0
   F2(100,J)=0.0
   F3(100,J)=0.0
   F4(100,J)=0.0
  ENDDO
  DO I=1,NX
   F1(I,NY)=0.0
   F2(I,NY)=0.0
   F3(I,NY)=0.0
   F4(I,NY)=0.0
   F1(I,0)=F1(I,1)
   F2(I,0)=F2(I,1)
   F3(I,0)=F3(I,1)
   F4(I,0)=F4(I,1)
  ENDDO
  DO J=0,NY
   DO I=0,NX
    RHO(I,J)=F1(I,J)+F2(I,J)+F3(I,J)+F4(I,J)
   ENDDO
  ENDDO
   DO J = 0,NY
   DO I = 0,NX
    WRITE(22,*) X(I), Y(J), RHO(I,J)
   ENDDO
 ENDDO
 ENDDO
! end of the main loop
 CLOSE(22)
 STOP
 END









