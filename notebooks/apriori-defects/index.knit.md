---
title: "Apriori analysis for quality assurance"
author: "Carmine Minichini"
description: "Priori Patterns for Posterior Perfection"
date: "2024-08-09"
categories: [R, Apriori analysis]
image: basket.gif
format:
  html:
    code-fold: false
---






The Apriori algorithm is a data mining technique that can help identify frequent patterns and associations among defects or issues encountered during process management activities. Instead of analyzing individual defects in isolation, the **Apriori** ^[[Apriori wikipedia page](https://en.wikipedia.org/wiki/Apriori_algorithm)] algorithm allows us to uncover relationships between different types of defects or issues that often occur together.

![](https://data-mining.philippe-fournier-viger.com/wp-content/uploads/2013/03/tdb.png){fig-align="center" width="33%"}

In the context of process management quality assurance, the algorithm works as follows:

1.  It analyzes the defect or issue data to identify the most frequently occurring individual defects or issues across multiple process instances or scenarios.

2.  It then looks for combinations of defects or issues that frequently co-occur, starting with pairs, then triplets, and so on.

3.  The algorithm calculates two key metrics for each defect or issue combination:

    -   **Support**: The proportion of process instances or scenarios in which a particular combination of defects or issues was observed.
    -   **Confidence**: The likelihood that if one defect or issue is present, the other defect(s) or issue(s) in the combination will also be found.

By analyzing these metrics, the Apriori algorithm can reveal meaningful associations between different types of defects or issues in the process management context. For example, it may uncover that a particular defect X and issue Y often occur together with high confidence, suggesting a potential root cause or shared underlying problem in the process.

These insights can be valuable for the quality assurance team in several ways:

1.  **Prioritizing process improvement efforts**: Defect and issue associations can help prioritize process areas or scenarios that are more likely to encounter multiple defects or issues simultaneously, enabling targeted improvement initiatives.

2.  **Root cause analysis**: Identifying strong associations between defects and issues can provide clues about potential root causes or shared underlying problems in the processes, leading to more effective defect prevention and remediation strategies.

3.  **Process optimization**: By understanding defect and issue co-occurrence patterns, the team can optimize processes to address multiple defects or issues more efficiently, reducing redundant efforts.

4.  **Defect and issue prediction**: The identified associations can potentially be used to predict the likelihood of encountering certain defects or issues based on the presence of others, enabling proactive mitigation measures.


::: {.cell hash='index_cache/html/unnamed-chunk-2_f8647100dc75740a6bfe97fbd262d022'}

```{.r .cell-code}
rules <- apriori(trans,
                 parameter = list(supp=3/length(items_list), #<1>
                                  conf=0.1, #<2>
                                  target= "rules"),
                 control = list(verbose=FALSE))
```
:::


1. 3/length(df) means minimum 3 out of total transactions must contain an itemset for it to be considered frequent
2. conf=0.1 means the minimum confidence threshold is set to 0.1 or 10%. This filters out association rules where the consequent (right-hand side) occurs less than 10% of the times when the antecedent (left-hand side) occurs

# Lift

The lift of a rule `{X} -> {Y}` is defined as

$$\text{lift}({X} \rightarrow {Y}) = \frac{P({Y} | {X})}{P({Y})}$$

where $P({Y} | {X})$ is the conditional probability of observing $Y$ given $X$, and $P({Y})$ is the probability of observing $Y$. A lift value greater than 1 indicates that the co-occurrence of $X$ and $Y$ is higher than expected if they were statistically independent, while a lift value less than 1 indicates that the co-occurrence is lower than expected.


::: {.cell hash='index_cache/html/unnamed-chunk-3_86f7e44a0b2853676d5c312a1c33dba5'}
::: {.cell-output-display}
```{=html}
<div class="reactable html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-e7df09fdb64123b2aa60" style="width:auto;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-e7df09fdb64123b2aa60">{"x":{"tag":{"name":"Reactable","attribs":{"data":{"Rule":[1,2,3,4,5,6,7,8,9,10,11,12],"rules":["{} => {D_1}","{} => {D_0}","{D_18} => {D_7}","{D_41} => {D_23}","{D_16} => {D_11}","{D_11} => {D_16}","{D_2} => {D_1}","{D_11} => {D_7}","{D_10} => {D_7}","{D_10} => {D_1}","{D_23} => {D_0}","{D_0} => {D_23}"],"Lift":[1,1,8.39,5.27,6,6,1.24,1.44,1.28,1.41,1.51,1.51],"Support":[0.1,0.17,0,0,0.01,0.01,0,0.01,0.01,0.01,0.02,0.02],"Confidence":[0.1,0.17,0.75,0.38,0.31,0.13,0.12,0.13,0.11,0.14,0.26,0.11]},"columns":[{"id":"Rule","name":"Rule","type":"numeric","width":50,"align":"center"},{"id":"rules","name":"X ⇒ Y","type":"character","filterable":true},{"id":"Lift","name":"Lift","type":"numeric","width":60,"align":"center","style":[{"background":"#FFFFFF"},{"background":"#FFFFFF"},{"background":"#0085A1"},{"background":"#6BB8C8"},{"background":"#52ACBF"},{"background":"#52ACBF"},{"background":"#F6FBFB"},{"background":"#EFF7F9"},{"background":"#F5FAFB"},{"background":"#F0F8F9"},{"background":"#EDF6F8"},{"background":"#EDF6F8"}]},{"id":"Support","name":"Support","type":"numeric","width":80,"align":"center"},{"id":"Confidence","name":"Confidence","type":"numeric","width":100,"align":"center","style":[{"background":"#FFFFFF"},{"background":"#FFF4E6"},{"background":"#FF9F1A"},{"background":"#FFD59C"},{"background":"#FFDFB5"},{"background":"#FFFAF4"},{"background":"#FFFCF7"},{"background":"#FFFAF4"},{"background":"#FFFDFB"},{"background":"#FFF9F0"},{"background":"#FFE7C6"},{"background":"#FFFDFB"}]}],"defaultPageSize":6,"showPageSizeOptions":true,"pageSizeOptions":[6,5],"dataKey":"6d1aea19a034e3fbdc337ab9557168dc"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}</script>
```
:::
:::


## Lift: interpretation

Let's define the following:

$X$ = $D_{18}$

$Y$ = $D_7$

The probability of the defect $D_7$ occurring, without considering any other factors, is **5%**. In other words, in **5%** of all cases, the defect $D_7$ is present.

However, when you look at cases where the defect $D_{18}$ is present, you find that the probability of the defect $D_7$ occurring is ~41.9%.

Using the lift formula, we can calculate the lift of the rule "$D_{18}$ → $D_7$" as follows:

$$\text{lift}({X} \rightarrow {Y}) = \frac{P({Y} | {X})}{P({Y})} = \frac{0.419}{0.05} = 8.39$$

The lift value of **8.39** indicates that when the defect $D_{18}$ is present, the probability of the defect $D_7$ occurring is 8.39 times higher than the probability of the defect $D_7$ occurring without considering the presence of $D_{18}$.

In other words, if the defect $D_{18}$ is present, it is a strong indicator or warning sign that the defect $D_7$ is likely to occur as well. This positive correlation between the two defects could be valuable for identifying root causes, implementing preventive measures, or prioritizing process improvements in the system or process where these defects are observed.

The lift value greater than 1 suggests that the occurrence of $D_{18}$ and $D_7$ together is not independent or random, but rather there is a strong positive association between the two defects. This information can be used to further investigate the relationship between $D_{18}$ and $D_7$ and potentially uncover underlying factors or dependencies that contribute to their co-occurrence.

# Confidence

The confidence of a rule `{X} -> {Y}` is defined as

$$\text{confidence}({X} \rightarrow {Y}) = P({Y} | {X})$$

where $P({Y} | {X})$ is the conditional probability of observing $Y$ given $X$.

The confidence metric measures how reliable or trustworthy the association rule `{X} -> {Y}` is. It represents the proportion of transactions containing $X$ that also contain $Y$. In other words, it answers the question: "When $X$ occurs, how often does $Y$ also occur?"

A confidence value closer to 1 (or 100%) indicates a stronger association between $X$ and $Y$, meaning that if $X$ is present in a transaction, we can be more confident that $Y$ will also be present. Conversely, a confidence value closer to 0 suggests a weaker association, implying that the presence of $X$ does not reliably indicate the presence of $Y$.


::: {.cell hash='index_cache/html/unnamed-chunk-4_e10953b8dad19252a1a1162bdd437f5e'}

```{.r .cell-code}
plot(rules,
     method = "graph",
     engine = "htmlwidget",
     shading = "confidence") #<1>
```

::: {.cell-output-display}
```{=html}
<div class="visNetwork html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-3608664de58b5eb34bd0" style="width:100%;height:464px;"></div>
<script type="application/json" data-for="htmlwidget-3608664de58b5eb34bd0">{"x":{"nodes":{"id":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22],"label":["D_0","D_1","D_10","D_11","D_16","D_18","D_2","D_23","D_41","D_7","rule 1","rule 2","rule 3","rule 4","rule 5","rule 6","rule 7","rule 8","rule 9","rule 10","rule 11","rule 12"],"group":[1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2],"value":[1,1,1,1,1,1,1,1,1,1,59,100,1,1,2,2,1,2,2,3,9,9],"color":["#CBD2FC","#CBD2FC","#CBD2FC","#CBD2FC","#CBD2FC","#CBD2FC","#CBD2FC","#CBD2FC","#CBD2FC","#CBD2FC","#EEDCDC","#EECDCD","#EE1B1B","#EEA2A2","#EEB0B0","#EED5D5","#EED7D7","#EED5D5","#EED9D9","#EED2D2","#EEBCBC","#EEDBDB"],"title":["D_0","D_1","D_10","D_11","D_16","D_18","D_2","D_23","D_41","D_7","<B>[1]<\/B><BR><B>{}<\/B><BR>&nbsp;&nbsp; => <B>{D_1}<\/B><BR><BR>support = 0.101<BR>confidence = 0.101<BR>coverage = 1<BR>lift = 1<BR>count = 61<BR>order = 1<BR>id = 1","<B>[2]<\/B><BR><B>{}<\/B><BR>&nbsp;&nbsp; => <B>{D_0}<\/B><BR><BR>support = 0.169<BR>confidence = 0.169<BR>coverage = 1<BR>lift = 1<BR>count = 102<BR>order = 1<BR>id = 2","<B>[3]<\/B><BR><B>{D_18}<\/B><BR>&nbsp;&nbsp; => <B>{D_7}<\/B><BR><BR>support = 0.00497<BR>confidence = 0.75<BR>coverage = 0.00662<BR>lift = 8.39<BR>count = 3<BR>order = 2<BR>id = 3","<B>[4]<\/B><BR><B>{D_41}<\/B><BR>&nbsp;&nbsp; => <B>{D_23}<\/B><BR><BR>support = 0.00497<BR>confidence = 0.375<BR>coverage = 0.0132<BR>lift = 5.27<BR>count = 3<BR>order = 2<BR>id = 4","<B>[5]<\/B><BR><B>{D_16}<\/B><BR>&nbsp;&nbsp; => <B>{D_11}<\/B><BR><BR>support = 0.00662<BR>confidence = 0.308<BR>coverage = 0.0215<BR>lift = 6<BR>count = 4<BR>order = 2<BR>id = 5","<B>[6]<\/B><BR><B>{D_11}<\/B><BR>&nbsp;&nbsp; => <B>{D_16}<\/B><BR><BR>support = 0.00662<BR>confidence = 0.129<BR>coverage = 0.0513<BR>lift = 6<BR>count = 4<BR>order = 2<BR>id = 6","<B>[7]<\/B><BR><B>{D_2}<\/B><BR>&nbsp;&nbsp; => <B>{D_1}<\/B><BR><BR>support = 0.00497<BR>confidence = 0.125<BR>coverage = 0.0397<BR>lift = 1.24<BR>count = 3<BR>order = 2<BR>id = 7","<B>[8]<\/B><BR><B>{D_11}<\/B><BR>&nbsp;&nbsp; => <B>{D_7}<\/B><BR><BR>support = 0.00662<BR>confidence = 0.129<BR>coverage = 0.0513<BR>lift = 1.44<BR>count = 4<BR>order = 2<BR>id = 8","<B>[9]<\/B><BR><B>{D_10}<\/B><BR>&nbsp;&nbsp; => <B>{D_7}<\/B><BR><BR>support = 0.00662<BR>confidence = 0.114<BR>coverage = 0.0579<BR>lift = 1.28<BR>count = 4<BR>order = 2<BR>id = 9","<B>[10]<\/B><BR><B>{D_10}<\/B><BR>&nbsp;&nbsp; => <B>{D_1}<\/B><BR><BR>support = 0.00828<BR>confidence = 0.143<BR>coverage = 0.0579<BR>lift = 1.41<BR>count = 5<BR>order = 2<BR>id = 10","<B>[11]<\/B><BR><B>{D_23}<\/B><BR>&nbsp;&nbsp; => <B>{D_0}<\/B><BR><BR>support = 0.0182<BR>confidence = 0.256<BR>coverage = 0.0712<BR>lift = 1.51<BR>count = 11<BR>order = 2<BR>id = 11","<B>[12]<\/B><BR><B>{D_0}<\/B><BR>&nbsp;&nbsp; => <B>{D_23}<\/B><BR><BR>support = 0.0182<BR>confidence = 0.108<BR>coverage = 0.169<BR>lift = 1.51<BR>count = 11<BR>order = 2<BR>id = 12"],"shape":["box","box","box","box","box","box","box","box","box","box","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle"],"x":[-0.8057550816801374,0.4270410191854774,0.9797337859570998,0.427323737210545,-0.02630754583657424,0.077911814714825,-0.2039412187995977,-0.8294945752918366,-0.6829601700053052,0.7234048811528702,0.4776671065232867,-0.7371616305712516,0.3811148827109767,-0.7830333608138292,0.2928018394440939,0.07219997208531725,0.07519607035969056,0.719599829963252,1,0.7491509923025181,-0.644084179915823,-1],"y":[0.3766167522057773,0.731059452102887,0.3147055529419562,-0.7313093774703696,-0.9791164140013381,0.04994243880882832,0.9289212051728275,-0.1545396410792941,-0.7398429760937298,-0.2052104497557287,1,0.6739314221241988,-0.05982446994928547,-0.4713921082734615,-1,-0.7155754201694613,0.8098856986291874,-0.5373375264370224,-0.003506490407269247,0.5601847596802134,0.1093682080244738,0.1178896937864444]},"edges":{"from":[6,9,5,4,7,4,3,3,8,1,11,12,13,14,15,16,17,18,19,20,21,22],"to":[13,14,15,16,17,18,19,20,21,22,2,1,10,8,4,5,2,10,10,2,1,8],"arrows":["to","to","to","to","to","to","to","to","to","to","to","to","to","to","to","to","to","to","to","to","to","to"]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot","physics":false},"manipulation":{"enabled":false},"edges":{"smooth":false},"physics":{"stabilization":false},"interaction":{"hover":true,"zoomSpeed":1}},"groups":["1","2"],"width":null,"height":null,"idselection":{"enabled":true,"style":"width: 150px; height: 26px","useLabels":true,"main":"Select by id"},"byselection":{"enabled":false,"style":"width: 150px; height: 26px","multiple":false,"hideColor":"rgba(200,200,200,0.5)","highlight":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)","igraphlayout":{"type":"square"},"tooltipStay":300,"tooltipStyle":"position: fixed;visibility:hidden;padding: 5px;white-space: nowrap;font-family: verdana;font-size:14px;font-color:#000000;background-color: #f5f4ed;-moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;border: 1px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);","highlight":{"enabled":true,"hoverNearest":true,"degree":1,"algorithm":"all","hideColor":"rgba(200,200,200,0.5)","labelOnly":true},"collapse":{"enabled":false,"fit":false,"resetHighlight":true,"clusterOptions":null,"keepCoord":true,"labelSuffix":"(cluster)"}},"evals":[],"jsHooks":[]}</script>
```
:::
:::


1. Nodes with higher confidence rules will be shaded darker, allowing you to visually identify the most confident association rules at a glance

## Confidence: interpretation

Based on the confidence value of 0.75 for the association rule X → Y, where:

$X$ = $D_{18}$

$Y$ = $D_7$

We can draw the following conclusions:

1.  **Strong association**: A confidence value of 0.75 indicates a relatively strong association between the two variables. This means that when $D_{18}$ error occurs, there is a 75% probability that the $D_7$ will follow as error.

2.  **Process improvement opportunity**: The strong association between X and Y could indicate potential issues or inefficiencies in the stakeholder notification process. It may be beneficial to review and improve the process to prevent errors.
