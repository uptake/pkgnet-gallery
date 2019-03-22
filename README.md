# Welcome to the [pkgnet](https://uptakeopensource.github.io/pkgnet/index.html) Gallery Repository!

Please visit [the pkgnet website](https://uptakeopensource.github.io/pkgnet/index.html) to view the gallery. See below for how to contribute.

# FAQs

### How can I contribute an example to the gallery? 
Submit a pull request to this repository that, at minimum, adds html code to `vignettes/pkgnet-gallery.Rmd` following this format:

```HTML
<td width="33%">[Your Package Name]<br>
	<a href="[URL to your package report]">
		<img width="300" src="[URL to your image]">
	</a>
</td>
```

A function to help create gallery exhibits (particularly the images) will soon be available in [pkgnet](https://uptakeopensource.github.io/pkgnet/index.html).  However, if choose to create your example report and image independently, it's preferred that you create your image in the same size and style as the others in the gallery for aesthetics.

If you would like to host your examples on this repository as well, include their addition to the `exhibits` folder in your pull request as well. 

### Why is this a seperate repository? 
There are a few reasons:     
1. We would like to enable gallery updates more often than  [CRAN](https://CRAN.R-project.org/package=pkgnet) version updates.   
2. We would like to keep [the pkgnet website](https://uptakeopensource.github.io/pkgnet/index.html) in line with the last stable version of `pkgnet` (i.e. the [CRAN](https://CRAN.R-project.org/package=pkgnet) version).   
3. We would like to keep the [pkgnet github repository](https://github.com/UptakeOpenSource/pkgnet) small in size. 

By having the gallery content hosted here, we achieve all three of these things.

### Why are there so many seemingly extra files in this repository?
We want to make the transition from [the main pkgnet website](https://uptakeopensource.github.io/pkgnet/index.html) to the gallery page within that website as seamless as possible.  To do so, we create the gallery page with the same R package, [pkgdown](https://pkgdown.r-lib.org/index.html), that we use to create the main page with very similar configuration files. Since creating a section of a website outside of the R package directory is not standard functionality for [pkgdown](https://pkgdown.r-lib.org/index.html), we replicate a few files and folder structures [pkgdown](https://pkgdown.r-lib.org/index.html) expects here. 

### Isn't there a better why to do this? 
Most likely.  We've love for you to submit your ideas on the issues page of either this repository of the main pkgnet repository. 