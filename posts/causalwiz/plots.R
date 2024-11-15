#' @description
#' Updating geom colors
#' 
update_geom_defaults("point",   list(colour = '#0085A1'))
update_geom_defaults("line",   list(colour = '#0085A1'))

#' @description
#' Custom theme for plots
#' 
ctheme <- function(){
  theme(
    # Set black background
    plot.background = element_rect(fill = "#242728"),
    panel.background = element_rect(fill = "#242728"),
    
    # Set white text for all elements
    text = element_text(color = "#eaeaea"),
    axis.text = element_text(color = "#eaeaea"),
    axis.title = element_text(color = "#eaeaea"),
    title = element_text(face='italic',size=13),
    
    # Set green facet wrap labels
    strip.background = element_rect(fill = "#0085A1"),
    strip.text = element_text(color = "#eaeaea", face = "bold",size = 12),
    
    # Optional: adjust grid lines for better visibility
    panel.grid.major = element_line(color = "grey30"),
    panel.grid.minor = element_line(color = "grey20"),
    
    # Optional: set legend theme to match
    legend.background = element_blank(),
    legend.text = element_text(color = "#eaeaea"),
    legend.title = element_blank(),
    legend.position = 'top'
  )
}

#' @description
#' Covariates balance plot
#' 
cov_bal_plot <- function(XX,
                         unadjusted,
                         adjusted){
  
  # Create a data frame for plotting
  pdata <- data.frame(
    covariate = colnames(XX),
    unadjusted = unadjusted,
    adjusted = adjusted
  )
  # melting dataframe
  pdatamelt <- pdata %>%
    filter(covariate != "(Intercept)") %>%
    pivot_longer(cols = c(unadjusted, adjusted), names_to = "type", values_to = "value")
  
  p <- ggplot(pdatamelt,aes(x=value,y=factor(covariate))) +
    geom_point(size=3,color ='#eaeaea') +
    geom_vline(xintercept = seq(0,1,by=0.25),linetype = "dashed", color = "#eaeaea", alpha = 0.5) +
    facet_wrap(~type, ncol = 2) +
    labs(x = 'SMD',y=NULL,title='Covariates balance')
  
  
  return(p)
  
}
#' @description
#' Propensity score distribution plot
#'

prop_plot <- function(e.hat, W) {
  
  data.frame(ps = e.hat, treatment = as.factor(W)) %>%
    ggplot(aes(x = ps, fill = treatment)) +
    geom_density(alpha = 0.5) +
    labs(x = "Propensity Score", y = "Density", title = "Propensity Score Distribution") +
    scale_fill_manual(values = c("#0085A1", 'red'), 
                      labels = c("Control", "Treatment"))
}




