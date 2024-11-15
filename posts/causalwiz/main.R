library(ggplot2)
library(latex2exp)
library(lmtest)
library(sandwich)
library(grf)
library(glmnet)
library(splines)
library(reshape2)
library(samplingbook)
library(dplyr)
library(tidyr)
library(cowplot)
library(sensitivitymv)

# load dependencies
source('utils.R')
source('plots.R')

# settings
options(warn = -1)
# setting custom theme
theme_set(ctheme())

ipw_estimators <- function(data,
                           estimation_method,
                           outcome,
                           treatment,
                           covariates,
                           model_specification='linear') {
  
  # treatment variable ~ w
  tvar <- data[,treatment]
  
  # outcome variable ~ y
  ovar <- data[,outcome]
  
  cat('\nFormula:\n')
  
  # get formula w ~ covariates and create model matrix
  XX <- model.matrix(get_formula(covariates,model_specification),data)
  
  #' @section Estimations
  
  diffm <- lm(
    as.formula(paste0(outcome, '~', treatment)),data = data
  )
  
  cat('\n')
  
  cat('\nDifference-in-means estimation (benchmark):\n')
  
  print(
    coeftest(diffm, vcov=vcovHC(diffm, type='HC2'))[2,]
    )
  
  cat('\n')
  cat(
    paste(estimation_method,'estimation:\n')
  )
  
  if (estimation_method == 'AIPW'){
    # causal forest estimation
    forest <- causal_forest(
      X = XX,
      W = tvar,
      Y = ovar,
      num.trees = 100
    )
    # average treatment effect
    forest.ate <- average_treatment_effect(forest,
                                           method='AIPW')
    
    # propensity scores
    e.hat <- forest$W.hat
    
    # AIPW estimation results
    ate.results <- c(
      Estimate = unname(forest.ate[1]),
      "Std Error" = unname(forest.ate[2]),
      "t value" = unname(forest.ate[1])/ unname(forest.ate[2]),
      "Pr(>|t|)" = 2 * (1 - pnorm(abs(unname(forest.ate[1])/ unname(forest.ate[2]))))
    )
    print(ate.results)
    
    # estimation
    estimation <- unname(forest.ate[1])
    
  } else if (estimation_method == 'IPW'){
    
    # fitting logistic model
    logit <- cv.glmnet(x = XX,
                       y = tvar,
                       family = 'binomial')

    # propensity scores
    e.hat <- predict(logit,
                     XX,
                     s = 'lambda.min',
                     type = 'response')
    
    
    # IPW estimation results
    z <- ovar * (tvar / e.hat - (1 - tvar) / (1 - e.hat))
    
    ate.est <- mean(z)
    ate.se <- sd(z) / sqrt(length(z))
    ate.tstat <- ate.est / ate.se
    ate.pvalue <- 2*(pnorm(1 - abs(ate.est/ate.se)))
    
    ate.results <- c(
      Estimate = ate.est,
      "Std Error" = ate.se,
      "t value" = ate.tstat,
      "Pr(>|t|)" = ate.pvalue
    )
    print(ate.results)
    
    # estimation
    estimation <- ate.est
  }
  else{
    stop("Invalid method, please choose 'AIPW' or 'IPW'")
  }
  
  
  #' @returns a list with estimated value and ate results
  
  list(
    estimation_value = estimation,
    ate_results = ate.results,
    e_hat = e.hat,
    model_spec_matrix = XX,
    treatment_variable = tvar
  )
  
}