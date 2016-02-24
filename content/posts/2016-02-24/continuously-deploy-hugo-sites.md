+++
date = "2016-02-24T22:14:00+01:00"
draft = false
title = "Continuously deploy hugo sites"
slug = "continuously-deploy-hugo-sites"
tags = [ "hugo", "s3", "aws", "travis-ci", "continuous deployment" ]
categories = [ "hugo" ]
+++

TL;DR;

How to setup continuous deployment of a Hugo website hosted on Github to AWS S3
by using Travis CI as the build/deployment service.

<!--more-->

I finally did it. I setup something that builds my website and pushes it to AWS
S3.

To be able to follow along, you need a [Github](https://github.com/join)
account, an [AWS](http://aws.amazon.com/) account and you need to register on
[Travis-CI](https://travis-ci.org/).

You should also have the Travis CI CLI installed to be able to encrypt values
in the `.travis.yml` file.

I'm assuming that you have prior knowledge with AWS, Hugo and Git.

### Creating S3 bucket

So, first you need an S3 bucket where you can host your content. Go ahead and
create one and give it a unique name. My preference is to use the same name
for the bucket as you would use for the domain which will point to the bucket.

Example would be naming the bucket `example.com` if your website URL is
`http://example.com`.

So, with that done, onto the next task, making the bucket available to the world.

#### Set bucket policy

So, in the S3 console, navigate to your bucket, click on `Properties`, expand
`Permissions` and click on `Edit bucket policy`.

Paste the following and change `example.com` to your buckets name:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Allow Public Access to All Objects",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::example.com/*"
        }
    ]
}
```

Click `Save` and that's it! Your bucket is now available to the world. Onto the
next task, which is allowing Travis CI to push data to your bucket.

#### Create IAM user

Head over to the `IAM Console`. In the left menu, click on `Users`, then click
on `Create New Users`. Enter a username of your choice, I recommend `travis-ci`.
Then click `Create` and then `Download Credentials`. Remember where you save
the downloaded file, since you'll need the values in that file later on.

Next up, allowing the newly created user access to the previously created S3
bucket.

#### Create bucket policy

Head over to `Policies`, click `Create Policy`, click `Select` next to
`Create Your Own Policy`. Give the policy a name, like `example.com-access` or 
something nicer. Then write a description if you like. Then, copy the JSON below
and paste it into the `Policy Document` textbox and replace `example.com` with
the name of your bucket. Click `Create Policy` and you're done!

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1456258376000",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::example.com/*"
            ]
        }
    ]
}
```

Next, attaching the policy to the previously created user.

#### Attach policy to IAM user

So, head over to `Users` again and click on your `Travis CI` user. Click on the
`Permissions` tab and click on `Attach Policy` and find your previously created
policy, then click `Attach Policy`.

That's it for the AWS part! Next is creating a Travis CI build script.

### Creating Travis CI build script

So, to allow Travis CI do the magic, we need a build script.

Open your favorite text editor and paste the text below into your editor.

```
language: go
go:
  - 1.6

sudo: false

install:
  - go get github.com/spf13/hugo

script:
  - hugo

deploy:
  - provider: s3
    access_key_id: <access_key_id>
    secret_access_key: <secret_access_key>
    bucket: <bucket>
    region: eu-west-1
    local_dir: public
    skip_cleanup: true
```

Before we save, we need to change the `<access_key_id>`, `<secret_access_key>`
and `<bucket>`.

To safely store the access key id, secret access key and bucket name, Travis CI
provides you with a CLI tool to encrypt values. So, open up a terminal and write
this:

```
cd path/to/your/hugo/git/repository

travis encrypt "<access_key_id_>"
```

This will ask you to confirm the repository and then return a value looking like
this:

```
secure: "aaeeee..."
```

Simply copy that value and paste int your `.travis.yml` file one line below the
key you're setting the value for.

Repeat this for the `<secret_access_key>` and the `<bucket>` values.

The final file should look something like this:

```
language: go
go:
  - 1.6

sudo: false

install:
  - go get github.com/spf13/hugo

script:
  - hugo

deploy:
  - provider: s3
    access_key_id:
      secure: "gibberish"
    secret_access_key: 
      secure: "gibberish"
    bucket:
      secure: "gibberish"
    region: eu-west-1
    local_dir: public
    skip_cleanup: true
```

Save the file as `.travis.yml`, commit your changes and push to Github.

That's it! Now all you need to do is to connect your Github repository on
Travis CI, but that's pretty straightforward, just head over to the Travis CI
website and you'll be guided.

Got any questions? Did I miss something, spelling errors or other suggestions?
[Fork](https://github.com/hagbarddenstore/website#fork-destination-box) and
send me a pull request, or contact me on [Twitter](https://twitter.com/hagbarddenstore)
