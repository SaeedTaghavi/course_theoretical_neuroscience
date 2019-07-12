program singleHhNeuron
implicit none
real(8), parameter :: pi = 4.0d0*datan(1.0d0)
real (8) :: Cm =1.0
real (8) :: Vr = -65.0
! real (8) :: Vr = 0.0
real (8) :: ENa,EK,El
real(8) :: X(4) ,  dX_dt(4) 
real(8) :: dt
integer :: it
real(8) :: gNa, gK, gl, Iext
gNa=120.0
gK=36.0
gl=0.3
Iext=0.0
ENa = 115.0 + Vr
EK = -12.0 + Vr
El = 10.6 + Vr

dt =0.01
call initiate(X)

open(91,file="output.txt")
write(91,*)"#t " , " Iext " , " V " , " n ", " m ", " h "
do it=1,10000
    Iext=140.0
    call derivs(dX_dt,X,Cm, gNa, gK, gl, ENa, EK, El,Iext,Vr)
    call integrate_one_step(X,dX_dt,dt)
    write(91,*) it*dt, Iext, X(1),X(2),X(3),X(4)
    ! print *,it*dt, X
end do
close(91)

end program singleHhNeuron

subroutine initiate(X)
    implicit none
    real(8) :: X(4)
    real(8) :: V0, n0, m0, h0
    V0 = -65.0
    n0 = 0.31768111085600037
    m0 = 5.2934208791209428E-002
    h0 = 0.59610933633356666     
    X(1) = V0
    X(2) = n0
    X(3) = m0
    X(4) = h0
end subroutine initiate

subroutine integrate_one_step(X,dX_dt,dt)
    !forward euler integration
    implicit none
    real*8::X(4)      ! phases of rotators
    real*8::dX_dt(4)  ! rate of change of phases
    real*8:: dt
    X=(dX_dt*dt)+X
end subroutine integrate_one_step

subroutine derivs(dX_dt,X,Cm, gNa, gK, gl, ENa, EK, El,Iext,Vr)
    implicit none  
    real(8) :: X(4), dX_dt(4)  
    real(8) :: dV_dt, dn_dt, dm_dt, dh_dt
    real(8) :: Iext,Vr, V, n, m, h, Cm, gNa, gK, gl, ENa, EK, El

    V = X(1)
    n = X(2)
    m = X(3)
    h = X(4)

    dX_dt(1) = dV_dt(Iext,V,n,m,h,Cm,gNa,gK,gl,ENa,EK,El)
    dX_dt(2) = dn_dt(Vr,V, n)
    dX_dt(3) = dm_dt(Vr,V, m)
    dX_dt(4) = dh_dt(Vr,V, h)
end subroutine derivs

function dV_dt(Iext,V,n,m,h,Cm,gNa,gK,gl,ENa,EK,El)
    implicit none
    real(8) :: dV_dt
    real(8) :: Cm ,  ENa ,  EK ,  El ,  gNa ,  gK ,  gl 
    real(8) :: Iext ,  V ,  m ,  h,  n
    ! real(8) :: Ik,INa,Il
    dV_dt = ( Iext - (gNa*m*m*m*h*(V-ENa)) - (gK*n*n*n*n*(V-EK)) - (gl*(V-El)) ) / Cm
end function dV_dt

function dn_dt(Vr, V, n)
    implicit none
    real(8) :: dn_dt 
    real(8) :: Vr, V ,  n ,  alpha_n ,  beta_n
    dn_dt = alpha_n(Vr,V)*(1.0-n) -beta_n(Vr,V)*(n)
end function dn_dt

function dm_dt(Vr, V, m)
    implicit none
    real(8) :: dm_dt
    real(8) :: Vr, V ,  m ,  alpha_m ,  beta_m
    dm_dt = alpha_m(Vr,V)*(1.0-m) -beta_m(Vr,V)*(m)
end function dm_dt

function dh_dt(Vr, V, h)
    implicit none
    real(8) :: dh_dt
    real(8) :: Vr, V ,  h ,  alpha_h ,  beta_h
    dh_dt = alpha_h(Vr,V)*(1.0-h) -beta_h(Vr,V)*(h)
end function dh_dt

function alpha_n(Vr,V)
    implicit none
    real(8) :: alpha_n, V , Vr
    alpha_n = (0.1-0.01*(V-Vr))/(exp(1.0-0.1*(V-Vr))-1.0)
end function alpha_n

function beta_n(Vr,V)
    implicit none
    real(8) :: beta_n, V , Vr
    beta_n = 0.125d0*exp((Vr-V)/80.0)
end function beta_n

function alpha_m(Vr,V)
    implicit none
    real(8) :: alpha_m , V , Vr
    alpha_m = (2.5-0.1*(V-Vr))/(exp(2.5-0.1*(V-Vr))-1.0)
end function alpha_m

function beta_m(Vr,V)
    implicit none
    real(8) :: beta_m, V , Vr
    beta_m = 4.0d0 * exp((Vr-V)/18.0)
end function beta_m

function alpha_h(Vr,V)
    implicit none
    real(8) :: alpha_h , V , vr
    alpha_h = 0.07d0 * exp((Vr-V)/20.0)
end function alpha_h

function beta_h(Vr,V)
    implicit none
    real(8) :: beta_h, V , Vr
    beta_h = 1.0d0 / ( 1.0d0 + exp( 3.0 -0.1*(V-Vr) ))
end function beta_h
