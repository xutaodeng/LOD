##################################################################################
# Read Data
###################################################################################

pic='result.png'

a<-read.table('query.fa', header=F)
out.name<-'result.csv'

sample.names<-'sample'
 # a<-data.frame(a[,-c(1,2)])

 colors=c(
'red',
'blueviolet',
'darkorange',
'darkgreen',
'blue',
'green',
'black',
'darkgoldenrod1',
'dimgrey'
)

# titles=NULL 
L95<-NULL
L50<-NULL
L95.up<-NULL
L50.up<-NULL
L95.dn<-NULL
L50.dn<-NULL

	ns<-as.numeric(a[,2])
	d<-as.numeric(a[,3])
	con<-as.numeric(a[,1])
	con.pfu<-con
	dif<-log10(con)[1]-log10(con.pfu)[1]
	
	y<-NULL
	x<-NULL
	yy<-NULL
	xx<-NULL

	for(i in 1:length(d)){
		if (is.na(d[i])){
			next
		}
		nrep=ns[i]
		npos=d[i]
		npos.per=npos/nrep
		#npos=round(nrep*npos.per)
		nneg=nrep-npos
		y<-c(y, rep(1, npos))
		y<-c(y, rep(0, nneg))
		x<-c(x, rep(con[i], nrep))
		yy<-c(yy, npos.per)
		xx<-c(xx, con[i])
	}

	xx<-log10(rev(xx))
	x<-log10(x)
	yy<-rev(yy)

	##################################################################################
	# Logit plots
	###################################################################################
	fit<-glm(y~x, family = binomial(link = "probit"))

	rr<-predict(fit, data.frame(x = log10(c(seq(0.1,100,0.1),seq(101, 60000, 1)))), se.fit=T, type="response")
	lw=rr$fit-1.96*rr$se.fit
	hi=rr$fit+1.96*rr$se.fit
	for (kk in 2:length(hi)){ if (hi[kk]<hi[kk-1]){hi[kk]=hi[kk-1]}}
	for (kk in 2:length(lw)){ if (lw[kk]<lw[kk-1]){lw[kk]=lw[kk-1]}}
	lw[lw<0]<-0.00
	hi[hi>0.99] <-0.99999
	result<-cbind(c(seq(0.1,100,0.1),seq(101, 60000, 1)), rr$fit, rr$se.fit, lw, hi)

	colnames(result)<-c('concentration', 'LOD', 'StandardError', 'LowerBound95', 'UpperBound95')
	write.csv(result, 'curve.csv', row.names=F)
	
	i50=which.min(abs(result[,2]-0.5))
	LOD50=result[i50,1]
	i50.up=which.min(abs(result[,5]-0.5))
	LOD50.up=result[i50.up,1]
	i50.dn=which.min(abs(result[,4]-0.5))
	LOD50.dn=result[i50.dn,1]


	i95=which.min(abs(result[,2]-0.95))
	LOD95=result[i95,1]
	i95.up=which.min(abs(result[,5]-0.95))
	LOD95.up=result[i95.up,1]
	i95.dn=which.min(abs(result[,4]-0.95))
	LOD95.dn=result[i95.dn,1]

	L95<-c(L95, LOD95)
	L50<-c(L50, LOD50)
	L95.up<-c(L95.up, LOD95.up)
	L50.up<-c(L50.up, LOD50.up)
	L95.dn<-c(L95.dn, LOD95.dn)
	L50.dn<-c(L50.dn, LOD50.dn)

png(pic, width=5800, height=3600, res=600)
plot(xx, yy, xlim=c(min(xx)-1,max(xx)+3), ylim=c(-0.2, 1.2), xlab='Concentration', ylab="Detection Probability", 
	axes=F, col=colors[1], cex.lab=1.2)#, main='Dengue subtype 1 whole blood spiking results')
axis(side = 3, at=log10(c(.00001,.0001,.001,.01,.1,1, 10, 100, 1000, 10000, 100000))+dif, labels=c(.00001,.0001,.001,.01,.1,1, 10, 100, 1000, 10000, 100000))
mtext(side = 3, line = 2, 'Concentration')
curve(predict(fit, data.frame(x = x), type="response"), add = TRUE, col=colors[1], lwd=2)

axis(1, at = log10(c(.00001,.0001,.001,.01,.1,1, 10, 100, 1000, 10000, 100000,1000000)), labels = c(.00001,.0001,.001,.01,.1,1, 10, 100, 1000, 10000, 100000,1000000))
axis(2, at = seq(0,1,0.1))
box()
abline(h=0.5, lty=2)
abline(h=0.95, lty=2)
lines(log10(c(LOD50.dn, LOD50.up)), c(0.5, 0.5), col=colors[1])
lines(log10(c(LOD50.dn, LOD50.dn)), c(0.45, 0.55), col=colors[1])
lines(log10(c(LOD50.up, LOD50.up)), c(0.45, 0.55), col=colors[1])

lines(log10(c(LOD95.dn, LOD95.up)), c(0.95, 0.95), col=colors[1])
lines(log10(c(LOD95.dn, LOD95.dn)), c(0.9, 1), col=colors[1])
lines(log10(c(LOD95.up, LOD95.up)), c(0.9, 1), col=colors[1])

dev.off()

# print(L95.up)
# print(L95.dn)
# print(L50.up)
# print(L50.dn)

# leg<-paste('LOD95=', L95, 'LOD50=', L50)
# #leg=c(paste("LOD50=", LOD50, sep=''),paste("LOD95=", LOD95, sep=''))
# indice=1
# #if (plot.all) {indice=1}
# legend('right', titles, text.col =colors[indice:length(colors)], cex=1.1)
# #text(log10(L50)-0.1, 0.55, labels=L50, col=colors, cex=0.7)

LOD_50= paste(L50,'[',L50.up, ',', L50.dn, ']', sep='')
LOD_95= paste(L95,'[',L95.up, ',', L95.dn, ']', sep='')
# for (i in 1:length(colors))
# {
	# if (i<10){ypos=1.25; xpos=min(xx)-2+i*1.1}
	# else{ypos=1.15; xpos=min(xx)-2+(i-9)*1.1}
	# legend(x=xpos, y=ypos , lb95[i], text.col=colors[i], bty='n', cex=0.8)
# }
# legend(x=min(xx)-1.5,y=1.25, 'LOD95', bty='n', cex=0.8)

# for (i in 1:length(colors))
# {
	# if (i<10){ypos=-0.1; xpos=min(xx)-2+i*1.1}
	# else{ypos=-0.2; xpos=min(xx)-2+(i-9)*1.1}
	# legend(x=xpos, y=ypos , lb50[i], text.col=colors[i], bty='n', cex=0.8)
# }
# # legend(x=min(xx)-1.5,y=-.1, 'LOD50', bty='n', cex=0.8)

# dev.off()

out<-rbind(LOD_50, LOD_95)
write.table(out, 'LOD.txt', quote=F, col.names=F, sep='\t')