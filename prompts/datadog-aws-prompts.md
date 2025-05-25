# Datadog AWS Prompts - David Vrensk

## Prompt #1
Cursor Agent, claude-4-sonnet

I've inherited this project and need help figuring out the terraform stuff. Please study @tf and 1, give me a summary of what it does and 2, review it like you were doing a code review.

## Prompt #2
Cursor Agent, claude-4-sonnet

Right, it is for learning and development, so don't worry about high availability and backups. That said, the point is to do things well.
I'll be using the scripts to set up my own environment, in eu-north-1.  I have already updated the ami-ids. What else do I need to update, redo or delete?

## Prompt #3
Cursor Agent, claude-4-sonnet

Is there any point in keeping terraform.tfstate and its backup? Will they interfere or will they just be overwritten?

## Prompt #4
Cursor Agent, claude-4-sonnet

Please update so that EC2 instances use ssh key key-05ae3c3c649ef27c9.

## Prompt #5
Cursor Agent, claude-4-sonnet

I just ran `tofu plan` (I use opentofu; please note this for the future) and got a couple of warnings at the end. Can you fix them? If it's complicated, just let it be.

## Prompt #6
Cursor Agent, claude-4-sonnet

I ran `tofu apply` and everything worked. I'm surprised since I don't have my AWS keys in the environment. I do have a .env file a couple of levels up, and `aws configure` has the credentials too.  Do you know how `tofu` found the credentials?

## Prompt #7
Cursor Agent, claude-4-sonnet

outline a step by step procedure for connecting my Datadog account with my AWS setup.

## Prompt #8
Cursor Agent, claude-4-sonnet

Will this really work? the script runs as ec2-user and needs to do `sudo` a lot, but still tries to write to files in /etc/datadog-agent.

## Prompt #9
Cursor Agent, claude-4-sonnet

What's the difference between an API key and an application key in datadog?

## Prompt #10
Cursor Agent, claude-4-sonnet

This option does not exist. I see Cloudformation(recommended), Terraform and Manually.  Wouldn't terraform make a lot of sense here?

## Prompt #11
Cursor Agent, claude-4-sonnet

So what do I do with the long HCL that Datadog console gives me?

## Prompt #12
Cursor Agent, claude-4-sonnet

But there is not external id in the console (or even the HCL that it gives me).

## Prompt #13
Cursor Agent, claude-4-sonnet

Got an error. Could this be because we have two datadog-related files?

## Prompt #14
Cursor Agent, claude-4-sonnet

That failed.
Tell me, what's the advantage to rolling our own as we've been doing now instead of using what datadoc console gave us?

