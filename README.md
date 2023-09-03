# Discord Link Exporter

This is a series of small shell scripts that try to extract all links sent by a particular
user in a particular Discord server/guild and save them to a plain Markdown document

It consists of two scripts:

- `discord-extract.sh`: this makes the API calls to Discord that are functionally
equivalent to using Discord's search feature and outputs a list of URLs in `links`

NOTE: you HAVE to edit this script and fill in the required authentication info, cookies,
user ID and guild ID, all of which can be accomplished through the use of the web browser
version of Discord. For more info on the required info and how to get it, consult the shell
script's comments.

- `get-preview.sh`: this goes through the links specified in a file you specify and
saves the link in a Markdown document (the name of which you also specify as a CLI argument)
with the title and description fetched using the link preview capabilities that most
webpages have now, resorting to parsing if necessary as well.

For more info, see [webpreview](https://github.com/ludbek/webpreview/)

Ideally, you should generate all the URLs using `discord-extract.sh` first, then
apply some filtering to get rid of any junk URLs you don't need. Examples include:

- Tenor GIF URLs

- Discord media attachment links

- Discord channel links

After doing this pruning, you can run `get-preview.sh` on the remaining, useful
links and get a Markdown document with good keywords.

## Why?

- Refer back to these links even when Discord is down or server is unavailable

- Share them easily with friends who don't use Discord

- Archive them using scripts such as [archiveurl](https://git.sr.ht/~gotlou/archiveurl)

- Search them much faster and easily than Discord's inbuilt search

- Partially solve the sad shift of knowledge and people from public, searchable
forums into closed, proprietary chat platforms where searching is horrible and
issue duplication is the rule rather than the exception

## Roadmap

- Create incremental backup service so we can keep indexing newer links

- Create filtering script that can catch many common spam URLs (like aforementioned Tenor GIF links)
