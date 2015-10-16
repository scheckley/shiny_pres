
require(deSolve)
require(ggplot2)

mm <- function(time,init,parms) {
  with(as.list(c(init, parms)), {
    dS <- -k1f * S * E + k1r * ES
    dE <- -k1f * S * E + (k1r + k2) * ES
    dES <- k1f * S * E - (k1r + k2) * ES
    dP <- k2 * ES
    
    vmax <- sum(k2 * sum(E + ES))
    v <- sum((vmax * S) / (km + S))
    
    return(list(c(dS,dE,dES,dP),v=v))
  })
}


parms = c(k1f=1.0, k1r=1.0,k2=1.0,km=1.0)
init = c(S=1000, E=10, ES=0, P=0)
exp.time = seq(1,100,1.0)
  
out <- ode(y=init, times=exp.time, func = mm, parms=parms)
out <- as.data.frame(out) #convert for ggplot
  
  #output plots
p1 <- ggplot(data=out, aes(x=S, y=v)) +
  geom_line() +
  xlab("substrate concentration ([S]/t)") +
  ylab("rate of product formation ([P]/t)") +
  ggtitle("Reaction Rate")
  
plot(p1)