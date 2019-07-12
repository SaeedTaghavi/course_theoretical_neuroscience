program kuramoto
implicit none
integer,parameter::N=50             ! number of rotators
real*8,allocatable::theta(:)       ! phases of rotators
real*8,allocatable::dTheta_dt(:)   ! rate of change of phases
real*8,allocatable::omega(:)       ! natural frequencies 
real*8::mu_omega,sigma_omega       ! mean value and standard deviation of natural frequencies
real*8::K                          ! coupling const.
real*8:: t, tstop,dt                ! time, end time and time step for simulation
integer::num_t                     ! total number of time steps
real*8:: r , psi                   ! order parameter at the moment
integer::i


allocate(theta(N),dTheta_dt(N),omega(N))

K=2.0
mu_omega=0.0
sigma_omega=1.0
tstop=100.0
dt=0.001
num_t=int(tstop/dt)

theta=0.0
dTheta_dt=0.0
omega=0.0
t=0.d0
call initiate(theta,omega,N,mu_omega,sigma_omega)

call find_order_param(theta,N,r,psi)
call save_order_param(t,r,psi)
do i=1,num_t
    call derivs(dTheta_dt,theta,N,K,omega)
    call integrate_one_step(theta,dTheta_dt,N,dt)
    call find_order_param(theta,N,r,psi)
    t=i*dt
    call save_order_param(t,r,psi)
end do


end program kuramoto

subroutine save_order_param(t,r,psi)
    implicit none
    real*8::t             ! time
    real*8::r,psi         ! order complex order parameter at time t

    open(unit=91,file="order_param.txt",action="write",position="append")
    ! write(91,"(3f7.2)")t,r,psi
    write(91,*)t,r,psi
    close(91)

end subroutine save_order_param

subroutine find_order_param(theta,N,r,psi)
    ! computes the complex order parameterreturned as the variables r and psi,
    ! where r is the magnitude and psi is the angle
    implicit none
    integer::N            ! number of rotators
    real*8::theta(N)      ! phases of rotators
    real*8:: r , psi      ! order parameter at the moment
    real*8:: real_sum,imag_sum
    integer::j

    real_sum=0.d0
    imag_sum=0.d0
    do j=1,N
        real_sum=real_sum+dcos(theta(j))
        imag_sum=imag_sum+dsin(theta(j))
    end do
    real_sum=real_sum/N
    imag_sum=imag_sum/N

    r=dsqrt((real_sum*real_sum)+(imag_sum*imag_sum))
    psi=dacos(real_sum/r)

end subroutine find_order_param

subroutine integrate_one_step(theta,dTheta_dt,N,dt)
    !forward euler integration
    implicit none
    integer::N            ! number of rotators
    real*8::theta(N)      ! phases of rotators
    real*8::dTheta_dt(N)  ! rate of change of phases
    real*8:: dt

    theta=(dTheta_dt*dt)+theta
end subroutine integrate_one_step

subroutine derivs(dTheta_dt,theta,N,K,omega)
    implicit none
    integer::N           ! number of rotators
    real*8::theta(N)     ! phases of rotators
    real*8::omega(N)     ! natural frequencies 
    real*8::K            ! coupling const.
    real*8::dTheta_dt(N)  ! rate of change of phases
    real*8:: sumation
    integer::i,j
    do i =1,N
        sumation=0.0
        do j=1,N
            sumation = sumation + sin(theta(j)-theta(i))
        end do
        sumation = sumation * K/N
        sumation = sumation + omega(i)
        dTheta_dt (i) = sumation
    end do
end subroutine derivs

subroutine save_vector(vec,vec_size)
    implicit none
    integer::vec_size,i
    real*8::vec(vec_size)
    ! open(91,file="filename")
    do i=1,vec_size
        write(1,"(f7.2)") vec(i)
    end do
end subroutine save_vector

subroutine initiate(theta,omega,N,mu_omega,sigma_omega)
    implicit none
    integer::N           ! number of rotators
    real*8::theta(N)     ! phases of rotators
    real*8::omega(N)     ! natural frequencies 
    real*8::mu_omega,sigma_omega  ! mean value and standard deviation of the gaussian distribution function
    call initiate_theta(theta,N)
    call initiate_omega(omega,N,mu_omega,sigma_omega)
end subroutine initiate

subroutine initiate_theta(theta,N)
    implicit none
    real*8,parameter::pi=4.0d0*datan(1.0d0)
    integer::N           ! number of rotators
    real*8::theta(N)     ! phases of rotators
    !theta(i) is choosen from a uniform random dist. in (0,2*pi)
    call random_number(theta)
    theta=theta*2.0*pi
end subroutine initiate_theta

subroutine  initiate_omega(omega,N,mu,sigma)
    implicit none
    integer::N           ! number of rotators
    real*8::omega(N)     ! natural frequencies 
    real*8::mu,sigma     ! mean value and standard deviation of the gaussian distribution function for natural frequencies
    !omega(i) is choosen from a gaussian dist. with mean value mu and standard deviation sigma
    call random_gaussian(omega,N,mu,sigma)
end subroutine  initiate_omega

subroutine random_gaussian(vec,vec_size,mu,sigma)
    implicit none
    integer::vec_size
    real*8::vec(vec_size)    ! random variable with a gaussian distribution of mean value mu, and standard deviation sigma
    real*8::z(vec_size)      ! random variable with a standard gaussian distribution, mu=0.0, sigma=1.0
    real*8::mu,sigma         ! mean value and standard deviation of the gaussian distribution function
    call random_standard_gaussian(z,vec_size)
    vec=(z*sigma)+mu
end subroutine random_gaussian


subroutine random_standard_gaussian(vec,vec_size)
    implicit none
    !using Box-Muller transform
    real*8,parameter::pi=4.0d0*datan(1.0d0)
    integer::vec_size
    real*8::vec(vec_size)
    real*8::u1(vec_size),u2(vec_size)    ! two independent random number from a uniform distribution on the interval (0,1)
    real*8::z1(vec_size),z2(vec_size)    ! two independent random variable with a standard gaussian distribution, mu=0.0, sigma=1.0
    real*8::r(vec_size),theta(vec_size)
    
    call random_number(u1)
    call random_number(u2)
    
    r=sqrt(-2.0*log(u1))
    theta=2.0*pi*u2
    
    z1=r*sin(theta)
    z2=r*cos(theta)
    vec=z1
end subroutine random_standard_gaussian
