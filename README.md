
# tankr - ranking changes over time

I wrote this package to visually track changes in rankings over time. It's original purpose was to help with search engine tuning.  By monitoring the search rankings of products over time on ecommerce sites, you can understand their volatility and what factors (such as search tuning) can influence these rankings.  

Here is an example of what this looks like:  This plot shows hourly changes in the top 50 search results for "home styles" on hayneedle.com, for a period of 100 hours. 

![example plot](/img/example.png?raw=true)

Different visual encodings can be used to emphasize aspects of the data.  The default encoding, shown here maps
 - intensity to the degree of change
 - color to the direction of change
 - black dots are used to show results that appear or disappear from the rankings
