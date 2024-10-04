from numpy.fft import fftfreq
import numpy as np
import matplotlib.pyplot as plt

#Define constants
eps0 = 8.8541878128e-12
mu0 = 1.256637062e-6
c0 = 1/np.sqrt(eps0*mu0)
imp0= np.sqrt(mu0/eps0)
print(c0)
print(imp0)
jmax = 500
jsource = 10
nmax = 2000

Ex = np.zeros(jmax)
Hz = np.zeros(jmax)
Ex_prev = np.zeros(jmax)
Hz_prev = np.zeros(jmax)
Trn = np.zeros(nmax, dtype = np.float64)
Ref = np.zeros(nmax, dtype = np.float64)
Ref_Src = np.zeros(nmax, dtype = np.float64)
Trn_Src = np.zeros(nmax, dtype = np.float64)
Ref_Src_Plot = np.zeros(nmax, dtype = np.float64)
Summed = np.zeros(nmax, dtype = np.float64)
imp = np.sqrt(mu0/eps0)
k = 0

32

lambda_min = 550e-9
dx = lambda_min/20
dt = dx/c0

eps = np.ones(jmax)*eps0
eps[230:250] = 16*eps0
eps[250:300] = 9*eps0
eps[300:320] = 16*eps0
material_prof = eps > eps0
imp = np.sqrt(mu0/eps)
#################### Source constants #################################
lambda_0 = 350e-9
w0 = 2*np.pi*c0/lambda_0
tau = 30
t0 = tau*3
tt = 0
Src = np.zeros(nmax, dtype = np.float64)
#######################################################################
#

def Source_Function(t):
tau = 30
t0 = tau*3
return 1*np.exp(-(t-t0)**2/tau**2)
for tt in range(nmax):
Src[tt] = 1*np.exp(-(tt-t0)**2/tau**2)

for n in range(nmax):
#Update magnetic field boundaries
Hz[jmax-1] = Hz_prev[jmax-2]
#Update magnetic field
for j in range(jmax-1):
Hz[j] = Hz_prev[j] + dt/(dx*mu0) * (Ex[j+1] - Ex[j])
Hz_prev[j] = Hz[j]
#Magnetic field source
Hz[jsource-1] -= Source_Function(n)/imp0
Hz_prev[jsource-1] = Hz[jsource-1]
# #Update electric field boundaries
Ex[0] = Ex_prev[1]
#Update electric field
for j in range(1, jmax):

33

Ex[j] = Ex_prev[j] + dt/(dx*eps[j])*(Hz[j] - Hz[j-1])
Ex_prev[j] = Ex[j]
if j == 1:
Ref[k] = Ex[1]
Trn[k] = Ex[jmax-1]
k = k+1
if k == 500:
quit
#Electric field source
Ex[jsource] += Source_Function(n+1)
Ex_prev[jsource] = Ex[jsource]

if n%10 == 0:
plt.plot(Ex)
plt.plot(material_prof)
plt.ylim([-1, 1])
plt.show()
plt.close()
plt.figure

#TRN FFT#############################
N = 2000
Lx = 2000
x = np.linspace(0, Lx, N)
freqs1 = fftfreq(N)
mask1 = freqs1 > 0
fft_vals1 = np.fft.fft(Trn)
fft_theo1 = 2.0*np.abs(fft_vals1/N)
fft_theo1 = fft_theo1
plt.figure(1)
plt.plot(x,Trn)
plt.figure(2)
plt.plot(freqs1[mask1], fft_theo1[mask1])
plt.xlim([0.0, 0.05])
plt.show()
######################################
#REF FFT#############################
N = 2000

34

Lx = 2000
x = np.linspace(0, Lx, N)
freqs2 = fftfreq(N)
mask2 = freqs2 > 0
fft_vals2 = np.fft.fft(Ref)
fft_theo2 = 2.0*np.abs(fft_vals2/N)
fft_theo2 = fft_theo2
plt.figure(3)
plt.plot(x,Ref)
plt.figure(4)
plt.plot(freqs2[mask2], fft_theo2[mask2])
plt.xlim([0.0, 0.05])
plt.show()
######################################
#SRC FFT#############################
N = 2000
Lx = 2000
x = np.linspace(0, Lx, N)
freqs3 = fftfreq(N)
mask3 = freqs3 > 0
fft_vals3 = np.fft.fft(Src)
fft_theo3= 2.0*np.abs(fft_vals3/N)
fft_theo3 = fft_theo3
plt.figure(3)
plt.plot(x,Src)
plt.figure(4)
plt.plot(freqs3[mask3], fft_theo3[mask3])
plt.xlim([0,0.025])
plt.ylim([0,1])
plt.show()
######################################
Ref_Src_Prop = np.divide(fft_theo2[mask2], fft_theo3[mask3])**2
Trn_Src_Prop = np.divide(fft_theo1[mask1] , fft_theo3[mask3])**2
summed_Trn = 0
summed_Ref = 0
for pp in range(49):

35

summed_Trn = summed_Trn + Trn_Src_Prop[pp]
for pp in range(49):
summed_Ref = summed_Ref + Ref_Src_Prop[pp]
print(summed_Trn/49)
print(summed_Ref/49)

#################################################3
Summed = np.add(Ref_Src_Prop, Trn_Src_Prop)
plt.figure(5)
plt.plot(freqs3[mask3], Ref_Src_Prop)
plt.plot(freqs3[mask3], Trn_Src_Prop)
plt.plot(freqs3[mask3], Summed)
plt.ylim([0,1.5])
plt.show()
