# Protocol Buffer (and gRPC) Management

This is a proposed set of guidelines, practices and tooling for managing `proto` files, as well as the creation and distribution of artifacts across multiple languages. 

## Why?
I work at a large organization that has multiple groups moving towards using both protobufs and gRPC.  When I looked at how different groups were integrating these things into they workflow and how they were being consumed, there did not seem to be a consistent solution.  Some teams were simply vendoring an upstream repo and generating the sources themselves, others had built some custom tooling to help their consumers (in a subset of possible languages) integrate their schemas.  Neither of these solutions really felt optimal to me and not having a consistent solution did not feel particularly scalable.
 
 Instead, it seemed like there should be consistent practices, tooling and automation around managing both the definitions and the artifacts that they produce would be extremely valuable.  With the popularity of both of these libraries, I assumed that there must be some well documented best practices that already existed.  However, when I started looking for prior art about how other companies manage these things I only found one blog post\[1\] that seemed applicable.  I was really hoping to find some industry best practices that we could simply adopt.  However when that did not work out I decided that I should just write one down and prototype it.

## Requirements
I started with a simple set of requirements that I drew from what I considered pretty standard best practices in software development:

* Semantic Versioning
* CI Builds
* CI Testing
* Publishing Artifacts
* Easy/Native Integration

## Approach

1. Store and manage the `proto` files in their own repository so that you can treat them as you would any other library and they can be easily consumed by multiple other projects
2. Generate the source code for each desired language as part of a CI process in that repo.
3. Build all the way to a standard artifact for that language.
4. Test against the artifacts as much as possible in the CI process.
5. Publish artifacts for each language in their "standard" way, including the proto files themselves.
6. Dependencies should consume the artifacts rather than the `proto` files themselves.

## Implementation
**Prototype**

I have put together a prototype version of the above process in this repo.  It leverages gradle to do the proto build because it seemed to have the richest set of features for both generating src across multiple languages and compiling and packaging the `java` artifacts.  It also supports downloading artifacts with protofiles in them and using them as dependencies, which is pretty nice.

Currently there is a slightly modified directory structure that removes an extra level that is normally included by gradle, I am not sure if that is worth while in the long run, but it does show that the gradle build can be configured to have a source and build directory structure that makes sense of your project.

The prototype generates and packages code in both `java` JAR files and `ruby` gem files.  It generates the gemspec on the fly, but has to delegate the gem file creating to a native ruby install, it might make more sense to use rbenv or something similar for a production version.

Finally, there is a Google Container Builder config file that will build, lint and package everything up.  Eventually this can be extended to also publish the results.


## Future Features
* More variables to control things like the version, artifact names, etc for the gradle build.
* Package all of the build work into a dockerfile and users only would need a `Makefile` and `cloudbuild.yaml`.
* Publish versioned tar for `proto` files themselves.
* Tooling to ping/list a running gRPC service?

## Related Projects
* [prototool](https://github.com/uber/prototool)
  * This may be a useful tool for generating sources and some testing, but doesn't handle the packaging and publishing aspects of things.

## Footnotes
\[1\] [How We Build gRPC Services At Namely](https://medium.com/namely-labs/how-we-build-grpc-services-at-namely-52a3ae9e7c35)  
\[2\] [prototool](https://github.com/uber/prototool)  

