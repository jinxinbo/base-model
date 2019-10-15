import numpy as np
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
mu,sigma=100,15
x=mu+sigma*np.random.randn(10000)
#the histogram of the data,alpha是颜色参数
n,bins,patches=plt.hist(x,50,normed=1,facecolor='b',alpha=0.75)
# add a 'best fit' line
print(bins)
y=mlab.normpdf(bins,mu,sigma)
plt.plot(bins,y,'r--')

plt.xlabel('smarts')
plt.ylabel('Probability')
plt.title('Histogram of IQ')

plt.text(60,.025,r'$\mu=100$, $\sigma=15$')

# plt.axis([40,160,0,0.03])

# 添加网格线
# plt.grid(True)

plt.subplots_adjust(left=0.15)
plt.show()

