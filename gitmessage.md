# [Guidelines for Writing Good Commit Messages](https://chris.beams.io/posts/git-commit)

## 7 Rules
1. Separate the subject from the body with a blank line
2. Limit subject line to 50 chars
3. Capitalize the subject line
4. Don't end the subject line with period
5. Use the imperative mood in the subject line
6. Wrap the body at 72 chars
7. Use the body to explain *what* and *why* vs *how*

## Subject Line
A properly formed Git commit subject line should always be able to complete the following sentence:

If applied, this commit will *your subject line here*

For example:

* If applied, this commit will *refactor subsystem X for readability*
* If applied, this commit will *update getting started documentation*
* If applied, this commit will *remove deprecated methods*
* If applied, this commit will *release version 1.0.0*
* If applied, this commit will *merge pull request #123 from user/branch*

## Template
```
Summarize changes in around 50 characters or less

More detailed explanatory text, if necessary. Wrap it to about 72
characters or so. In some contexts, the first line is treated as the
subject of the commit and the rest of the text as the body. The
blank line separating the summary from the body is critical (unless
you omit the body entirely); various tools like `log`, `shortlog`
and `rebase` can get confused if you run the two together.

Explain the problem that this commit is solving. Focus on why you
are making this change as opposed to how (the code explains that).
Are there side effects or other unintuitive consequences of this
change? Here's the place to explain them.

Further paragraphs come after blank lines.

 - Bullet points are okay, too

 - Typically a hyphen or asterisk is used for the bullet, preceded
   by a single space, with blank lines in between, but conventions
   vary here

If you use an issue tracker, put references to them at the bottom,
like this:

Resolves: #123
See also: #456, #789
```
### Git Commands to Investigate  
* `git blame`
* `git revert`
* `git rebase`
* `git shortlog`
* `git diff`
* `git show`
* `git log -p`
