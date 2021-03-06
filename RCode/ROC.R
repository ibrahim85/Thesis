roc_sys <- function(Mkt, SLoss, MktName,lw, up){
  # Rate of Change (ROC) system.
  #
  # Args:
  #   Mkt: market data 
  #   SLoss: stop loss 
  #   MktName: market's name for print out
  #   lw: value of ROC for reversal up
  #   up: value of ROC for reversal down
  #
  # Returns:
  #   results vector.
  
  results <- createResultsVector(MktName, SLoss)
  
  Mkt$prevROC <- c( NA, Mkt$roc[ - length(Mkt$roc) ] )
  
  # Trade Long
  Mkt$Long <- ifelse(Mkt$prevROC < lw,Mkt$Close-Mkt$Open,NA)
  results["LongPL"] <- round(sum(Mkt$Long, na.rm=TRUE))
  #Adj for SLoss
  if (SLoss < 0) {
    Mkt$Long <- ifelse(Mkt$prevROC < lw,
                       ifelse((Mkt$Low-Mkt$Open) < SLoss, SLoss, Mkt$Long),
                       Mkt$Long)
    results["LongPL"] <- round(sum(Mkt$Long, na.rm=TRUE))
  }
  
  # Trade Short
  Mkt$Short <- ifelse(Mkt$prevROC > up,Mkt$Open-Mkt$Close,NA)
  results["ShortPL"] <- round(sum(Mkt$Short, na.rm=TRUE))
  #Adj for SLoss
  if (SLoss < 0) {
    Mkt$Short <- ifelse(Mkt$prevROC > up,
                        ifelse((Mkt$Open-Mkt$High) < SLoss, SLoss, Mkt$Short),
                        Mkt$Short)
    results["ShortPL"] <- round(sum(Mkt$Short, na.rm=TRUE))
  }
  
  Stats <- calcStats(Mkt$Long)
  results[5:7] <- Stats

  Stats <- calcStats(Mkt$Short)
  results[8:10] <- Stats
  
  return(results)
}


