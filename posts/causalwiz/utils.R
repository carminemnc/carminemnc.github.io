
#' @description
#' Provide formula model specification
#' 
get_formula <- function(vars,
                        model_spec = 'linear') {
  # no manipulation
  if (model_spec == 'linear') {
    cat(
      paste(
        'w',
        paste("~", paste0(vars, collapse = "+"))
      )
    )
    # return
    fmla <- paste0("~", paste0(vars, collapse = "+"))
  } else if (model_spec == 'interaction') {
    # covariates interaction
    cat(
      paste(
        'w',
        paste("~ 0 +", paste(apply(expand.grid(covariates, covariates), 1, function(x) paste0(x, collapse="*")), collapse="+"))
      )
    )
    # return
    fmla <- paste("~ 0 +", paste(apply(expand.grid(covariates, covariates), 1, function(x) paste0(x, collapse="*")), collapse="+"))
  } else if (model_spec == 'splines'){
    # splines
    cat(
      paste(
        'w',
        paste("~", paste0("bs(", covariates, ", df=3)", collapse="+"))
      )
    )
    # return
    fmla <- paste0("~", paste0("bs(", covariates, ", df=3)", collapse="+"))
  }
  else {
    stop("Invalid model specification, please choose between 'default','interaction','splines'.")
  }
  
  return(as.formula(fmla))
}

#' @description
#' Calculate covariates balance metrics
#' 

aipw_balancer <- function(XX, W, e.hat) {

  # Unadjusted
  
  ## z_1 and z_0
  means.treat <- apply(XX[W == 1,], 2, mean)
  means.ctrl <- apply(XX[W == 0,], 2, mean)
  ## abs(z_1 - z_0)
  abs.mean.diff <- abs(means.treat - means.ctrl)
  ## s_1 and s_0
  var.treat <- apply(XX[W == 1,], 2, var)
  var.ctrl <- apply(XX[W == 0,], 2, var)
  ## sqrt(s_1 + s_0)
  std <- sqrt(var.treat + var.ctrl)
  ## abs(z_1 - z_0) / sqrt(s_1 + s_0) for Unadjusted
  unadjusted = abs.mean.diff / std
  
  # Adjusted
  
  ## z*w/e.hat
  means.treat.adj <- apply(XX * W / e.hat, 2, mean)
  ## z*(1-w)/(1-e.hat)
  means.ctrl.adj <- apply(XX * (1 - W) / (1 - e.hat), 2, mean)
  ## abs(z_1 - z_0)
  abs.mean.diff.adj <- abs(means.treat.adj - means.ctrl.adj)
  ## s_1 and s_0
  var.treat.adj <- apply(XX * W / e.hat, 2, var)
  var.ctrl.adj <- apply(XX * (1 - W) / (1 - e.hat), 2, var)
  ## sqrt(s_1 + s_0)
  std.adj <- sqrt(var.treat.adj + var.ctrl.adj)
  ## abs(z_1 - z_0) / sqrt(s_1 + s_0) for Adjusted
  adjusted = abs.mean.diff.adj / std.adj

  list(
    adjusted_cov = adjusted,
    unadjusted_cov = unadjusted
  )
}