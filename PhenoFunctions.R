# PhenoFunctions 
#### READ IN PHENOLOGY DATA 2016 ####
ReadInBodyPhenology2016 <- function(datasheet, site, year){
  # import body of data
  dat <- read.csv(datasheet, header=FALSE, sep=";", skip=3, stringsAsFactors=FALSE)
  dat <- dat[dat$V2!="",] # get rid of empty lines, where no species
  dat <- dat[,-3] # get rid of chinese names
  dat$V2<-gsub(" ", "", dat$V2,fixed = TRUE) # get rid of space
  
  # loop to get turfID in all cells
  for (i in 2:nrow(dat)){
  if(nchar(dat$V1[i])==0){
      dat$V1[i] <- dat$V1[i-1]
    }
  }
  # import head of data set
  dat.h <- read.csv(datasheet, sep=";", header=FALSE, nrow=3, stringsAsFactors=FALSE)
  
  # merge data into long data table
  long.table <- lapply(seq(3,ncol(dat)-15,16),function(i){
    x <- dat[ ,c(1:2,i:(i+15))]
    names(x) <- c("turfID", "species", paste(rep(c("b", "f", "s", "r"), 4  ), rep(1:4, each=4), sep="."))
    x$date <- strsplit(dat.h[1,i+1], "_")[[1]][1]
    x$doy <- yday(ymd(x$date))
    x  
  })
  dat.long <- do.call(rbind,c(long.table, stingsAsFactors=FALSE))

  # Extract site
  dat.long$origSite <- substr(dat.long$turfID, 1,1)
  dat.long$destSite <- site
  dat.long$block <- substr(dat.long$turfID, 2,2)
  dat.long$treatment <- substr(dat.long$turfID, 4,nchar(dat.long$turfID))
  # if treatmen 1 or 2, remove species with a *sp* (not from original data set)
  dat.long  <-  dat.long[
    (dat.long$treatment %in% c("1", "2") & grepl("\\*.*\\*", as.character(dat.long$species), perl = TRUE)) | #if treatment 1 or 2 only *sp*
      !(dat.long$treatment %in% c("1", "2")), ] # if other treatment
  dat.long$species <- gsub("*", "", dat.long$species,fixed = TRUE) # get rid of *
  
  # convert to factor and numeric
  dat.long <- cbind(dat.long[,c(1:2,19:24)],sapply(dat.long[,c(3:18)],as.numeric))
  #sapply(dat.long[,c(4:7,9:12,14:17,19:22)],function(x)print(grep("\\D", x = x, value = TRUE))) # Check error messages
  dat.long <- dat.long[-1,]
  dat.long$year <- year
  dat.long <- dat.long[-nrow(dat.long),] # remove strange last row
  dat.long
  return(dat.long)
}


#### READ IN 2017 data
ReadInBodyPhenology2017 <- function(datasheet, site, year){
  # import body of data
  dat <- read.csv(datasheet, header=FALSE, sep=";", skip=3, stringsAsFactors=FALSE)
  dat <- dat[dat$V2!="",] # get rid of empty lines, where no species
  dat <- dat[,-3] # get rid of chinese names
  dat$V2<-gsub(" ", "", dat$V2,fixed = TRUE) # get rid of space
  
  # loop to get turfID in all cells
  for (i in 2:nrow(dat)){
    if(nchar(dat$V1[i])==0){
      dat$V1[i] <- dat$V1[i-1]
    }
  }
  # import head of data set
  dat.h <- read.csv(datasheet, sep=";", header=FALSE, nrow=3, stringsAsFactors=FALSE)
  
  # merge data into long data table
  long.table <- lapply(seq(3,ncol(dat)-15,16),function(i){
    x <- dat[ ,c(1:2,i:(i+15))]
    names(x) <- c("turfID", "species", paste(rep(c("b", "f", "s", "r"), 4  ), rep(1:4, each=4), sep="."))
    x$date <- dat.h[1,i+1]
    x$doy <- yday(ymd(x$date))
    x  
  })
  dat.long <- do.call(rbind,c(long.table, stingsAsFactors=FALSE))
  
  # Extract site
  dat.long$origSite <- substr(dat.long$turfID, 1,1)
  dat.long$destSite <- site
  dat.long$block <- substr(dat.long$turfID, 2,2)
  dat.long$treatment <- substr(dat.long$turfID, 4,nchar(dat.long$turfID))
  
  
  # convert to factor and numeric
  dat.long <- cbind(dat.long[,c(1:2,19:24)],sapply(dat.long[,c(3:18)],as.numeric))
  #sapply(dat.long[,c(4:7,9:12,14:17,19:22)],function(x)print(grep("\\D", x = x, value = TRUE))) # Check error messages
  dat.long <- dat.long[-1,]
  dat.long$year <- year
  dat.long <- dat.long[-nrow(dat.long),] # remove strange last row
  dat.long
  return(dat.long)
}



#### READ IN EXTRA CONTROLS 2017
ReadInBodyPhenologyExtra <- function(datasheet, site, year){
  # import body of data
  dat <- read.csv(datasheet, header=FALSE, sep=";", skip=3, stringsAsFactors=FALSE)
  dat <- dat[dat$V2!="",] # get rid of empty lines, where no species
  dat <- dat[,-3] # get rid of chinese names
  dat$V2<-gsub(" ", "", dat$V2,fixed = TRUE) # get rid of space
  
  # loop to get turfID in all cells
  for (i in 2:nrow(dat)){
    if(nchar(dat$V1[i])==0){
      dat$V1[i] <- dat$V1[i-1]
    }
  }
  # import head of data set
  dat.h <- read.csv(datasheet, sep=";", header=FALSE, nrow=3, stringsAsFactors=FALSE)
  #browser()
  # merge data into long data table
  long.table <- lapply(seq(3,ncol(dat)-35,36),function(i){
    x <- dat[ ,c(1:2,i:(i+35))]
    names(x) <- c("turfID", "species", paste(rep(c("b", "f", "s", "r"), 9), rep(1:9, each=4), sep="."))
    x$date <- dat.h[1,i+1]
    x$doy <- yday(ymd(x$date))
    x  
  })
  dat.long <- do.call(rbind,c(long.table, stingsAsFactors=FALSE))
  
  # Extract site
  dat.long$origSite <- site
  dat.long$destSite <- site
  dat.long$block <- sub(".*\\-", "", dat.long$turfID) # place everything before - with blank
  dat.long$treatment <- "EC"
  
  
  # convert to factor and numeric
  dat.long <- cbind(dat.long[,c("turfID", "species", "date", "doy", "origSite", "destSite", "block", "treatment")],sapply(dat.long[,c(3:38)],as.numeric))
  #sapply(dat.long[,c(4:7,9:12,14:17,19:22)],function(x)print(grep("\\D", x = x, value = TRUE))) # Check error messages
  dat.long <- dat.long[-1,]
  dat.long$year <- year
  dat.long <- dat.long[-nrow(dat.long),] # remove strange last row
  dat.long
  return(dat.long)
}



# Calculate the sum of buds, flowers and seeds per turf and species
CalcSums <- function(dat){
  dat <- dat %>% 
  mutate(bud = rowSums(.[grep("b\\.", names(.))], na.rm = TRUE)) %>% 
  mutate(flower = rowSums(.[grep("f\\.", names(.))], na.rm = TRUE)) %>% 
  mutate(seed = rowSums(.[grep("s\\.", names(.))], na.rm = TRUE)) %>% 
  mutate(ripe = rowSums(.[grep("r\\.", names(.))], na.rm = TRUE))
  return(dat)
}



#### FUNCTIONS FOR FIGURES ####

### GET MEAN AND SE BY SPECIES ###
SpeciesMeanSE <- function(dat){
  # Calculate mean and se by species, pheno.stage, origSite, newTT
  MeanSE <- dat %>% 
    group_by(year, newTT, origSite, pheno.stage, pheno.var, species) %>% 
    summarise(N = sum(!is.na(value)), mean = mean(value, na.rm = TRUE), se = sd(value, na.rm = TRUE)/sqrt(N))
  
  # Calculate mean for difference between Control and Treatment
  #SPOnlyInOneTreatment
  SpeciesDifference <- MeanSE %>% 
    ungroup() %>% 
    select(-N) %>%  # remove site, because it causes problems
    unite(united, mean, se, sep = "_") %>% # unite mean and se
    spread(key = newTT, value = united) %>% # spread Treatments
    separate(col = Control, into = c("Control_mean", "Control_se"), sep = "_", convert = TRUE) %>% 
    separate(col = OTC, into = c("OTC_mean", "OTC_se"), sep = "_", convert = TRUE) %>% 
    separate(col = Warm, into = c("Warm_mean", "Warm_se"), sep = "_", convert = TRUE) %>% 
    separate(col = Cold, into = c("Cold_mean", "Cold_se"), sep = "_", convert = TRUE) %>% 
    mutate(OTC_mean = OTC_mean - Control_mean, Warm_mean = Warm_mean - Control_mean, Cold_mean = Cold_mean - Control_mean) %>% 
    mutate(OTC_se = sqrt(Control_se^2 + OTC_se^2), Warm_se = sqrt(Control_se^2 + Warm_se^2), Cold_se = sqrt(Control_se^2 + Cold_se^2)) %>% 
    select(-Control_mean, -Control_se) %>% 
    unite(OTC, OTC_mean, OTC_se, sep = "_") %>% 
    unite(Warm, Warm_mean, Warm_se, sep = "_") %>% 
    unite(Cold, Cold_mean, Cold_se, sep = "_") %>% 
    gather(key = Treatment, value = united, -year, -origSite, -pheno.stage, -pheno.var, -species) %>%
    separate(col = united, into = c("mean", "se"), sep = "_", convert = TRUE) %>% 
    filter(!is.na(mean))

  return(SpeciesDifference)
}    
    





### COMMUNITY DATA ###
PlotCommunityData <- function(dat, phenovar){    
    CommunityDifference <- dat %>% 
      mutate(newname = paste(origSite, Treatment, sep = "_")) %>% # paste Treatment and site, they are unique and can be renamed
      mutate(newname = plyr::mapvalues(newname, c("H_OTC", "A_OTC", "H_Transplant", "A_Transplant"), c("High alpine OTC", "Alpine OTC", "High alpine Transplant", "Alpine Transplant"))) %>% 
      mutate(newname = factor(newname, levels = c("High alpine OTC", "Alpine OTC", "High alpine Transplant", "Alpine Transplant"))) %>% 
      group_by(pheno.stage, newname) %>% 
      summarise(Difference = mean(mean, na.rm = TRUE), SE = mean(se, na.rm = TRUE)) %>% 
      mutate(Treatment = sub(".* ", "", newname))
  
  ggplot(CommunityDifference, aes(x = newname, y = Difference, color = Treatment, shape = Treatment, ymax = Difference + SE, ymin = Difference - SE)) +
    geom_hline(yintercept=0, color = "gray") +
    geom_point(size = 1.8) +
    labs(x = "", y = "Treatment - control in days") +
    scale_colour_manual(name = "", values = c("red", "purple")) +
    scale_shape_manual(name = "", values = c(16, 17)) +
    facet_grid(~ pheno.stage) +
    geom_errorbar(width=0.2) +
    scale_x_discrete(labels = c("High alpine OTC" = "High alpine", "Alpine OTC" = "Alpine", "High alpine Transplant" = "High alpine", "Alpine Transplant" = "Alpine", "High alpine OTC" = "High alpine", "Alpine OTC" = "Alpine", "High alpine Transplant" = "High alpine", "Alpine Transplant" = "Alpine", "High alpine OTC" = "High alpine", "Alpine OTC" = "Alpine", "High alpine Transplant" = "High alpine", "Alpine Transplant" = "Alpine", "High alpine OTC" = "High alpine", "Alpine OTC" = "Alpine", "High alpine Transplant" = "High alpine", "Alpine Transplant" = "Alpine")) +
    ggtitle(phenovar) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
}


### SPECIES DATA ###
PlotSpeciesData <- function(dat, phenovar, phenostage, Year){
  dat2 <- with(dat, expand.grid(year = unique(year), Treatment=unique(Treatment), species=unique(species), origSite = unique(origSite), pheno.stage = unique(pheno.stage))) %>%
    left_join(dat, by = c("year", "Treatment", "species", "origSite", "pheno.stage")) %>% 
    group_by(year, species, origSite) %>% 
    filter(sum(!is.na(mean)) > 0) %>% 
    ungroup()

  # Draw plot
dat2 %>% 
    filter(year == Year, pheno.var == phenovar, pheno.stage == phenostage) %>% 
    mutate(origSite = plyr::mapvalues(origSite, c("H", "A", "M"), c("High Alpine", "Alpine", "Middle"))) %>% 
    mutate(Treatment = plyr::mapvalues(Treatment, c("Cold", "OTC", "Warm"), c("Transplant Cold", "OTC", "Transplant Warm"))) %>% 
  mutate(Treatment = factor(Treatment, levels = c("OTC", "Transplant Warm", "Transplant Cold"))) %>% 
    ggplot(aes(y = mean, x = species, fill = Treatment, ymin = mean - se, ymax = mean + se)) +
    geom_col(position="dodge", width = 0.7) +
    geom_errorbar(position = position_dodge(0.7), width = 0.2) +
    geom_hline(yintercept = 0, colour = "grey", linetype = 2) +
    #scale_fill_manual(name = "", values = c("purple", "orange", "lightblue")) +
  labs(y = "Difference between treatment and control in days", x = "", title = phenovar) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
    facet_grid(pheno.stage ~ Treatment * origSite, scales = "free_x", space = "free_x")
}


PlotSpeciesData2 <- function(dat, phenovar, Year){
  dat %>% 
    filter(year == Year, pheno.var == phenovar, pheno.stage != "Ripe") %>% 
    #mutate(origSite = plyr::mapvalues(origSite, c("H", "A", "M"), c("High Alpine", "Alpine", "Middle"))) %>% 
    mutate(Treatment = plyr::mapvalues(Treatment, c("Cold", "OTC", "Warm"), c("Transplant Cold", "OTC", "Transplant Warm"))) %>% 
    mutate(Treatment = factor(Treatment, levels = c("OTC", "Transplant Warm", "Transplant Cold"))) %>% 
    mutate(origSite = plyr::mapvalues(origSite, c("A", "H", "M"), c("Alpine", "High alpine", "Mid"))) %>% 
    mutate(origSite = factor(origSite, levels = c("High alpine", "Alpine", "Mid"))) %>% 
    mutate(Order = paste(Treatment, origSite, species, sep = "_")) %>% 
    ggplot(aes(y = mean, x = species, fill = Treatment, ymin = mean - se, ymax = mean + se)) +
    geom_col(position="dodge", width = 0.7) +
    geom_errorbar(position = position_dodge(0.7), width = 0.2) +
    geom_hline(yintercept = 0, colour = "grey", linetype = 2) +
    scale_fill_manual(name = "", values = c(rep("purple", 1), rep("orange", 1), rep("lightblue", 1))) +
    #scale_x_discrete(labels = SP) +
    labs(y = "Difference between treatment and control in days", x = "", title = "peak phenophase") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position="top") + 
    facet_grid(pheno.stage ~ Treatment * origSite, scales = "free_x", space = "free_x")
}



#### FUNCTIONS FOR ANALYSIS ####
#### Function to produce model-checking plots for the fixed effects of an lmer model
ModelCheck <- function(mod){		
  par(mfrow = c(1,2))
  # Residual plot: checking homogeneity of the variance and linerarity
  plot(fitted(mod), resid(mod)) #should have no pattern
  abline(h=0)
  # QQnorm plot: normal distribution of the residuals
  qqnorm(resid(mod), ylab="Residuals")		  #should be approximately straight line
  qqline(resid(mod))
  }


### Test overdispersion
# compare the residual deviance to the residual degrees of freedom
# these are assumed to be the same.

overdisp_fun <- function(model) {
  ## number of variance parameters in 
  ##   an n-by-n variance-covariance matrix
  vpars <- function(m) {
    nrow(m)*(nrow(m)+1)/2
  }
  model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
  rdf <- nrow(model.frame(model))-model.df
  rp <- residuals(model,type="pearson")
  Pearson.chisq <- sum(rp^2)
  prat <- Pearson.chisq/rdf
  pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE)
  c(chisq=Pearson.chisq,ratio=prat,rdf=rdf,p=pval)
}


# Function to calculate QAICc
# NB, phi is the scaling parameter from the quasi-family model. If using e.g. a poisson family, phi=1 and QAICc returns AICc, or AIC if QAICc=FALSE.
QAICc <- function(mod, scale, QAICc = TRUE) {
  ll <- as.numeric(logLik(mod))
  df <- attr(logLik(mod), "df")
  n <- length(resid(mod))
  if (QAICc)
    qaic = as.numeric(-2 * ll/scale + 2 * df + 2 * df * (df + 1)/(n - df - 1))
  else qaic = as.numeric(-2 * ll/scale + 2 * df)
  qaic
}


# Model selection
modsel <- function(mods,x){	
  phi=1
  dd <- data.frame(Model=1:length(mods), K=1, QAIC=1)
  for(j in 1:length(mods)){
    dd$K[j] = attr(logLik(mods[[j]]),"df")
    dd$QAIC[j] = QAICc(mods[[j]],phi)
  }
  dd$delta.i <- dd$QAIC - min(dd$QAIC)
  dd <- subset(dd,dd$delta.i<x)
  dd$re.lik <- round(exp(-0.5*dd$delta.i),3)
  sum.aic <- sum(exp(-0.5*dd$delta.i))
  wi <- numeric(0)
  for (i in 1:length(dd$Model)){wi[i] <- round(exp(-0.5*dd$delta.i[i])/sum.aic,3)}; dd$wi<-wi
  print(dds <- dd[order(dd$QAIC), ])
  assign("mstable",dd,envir=.GlobalEnv)
}
