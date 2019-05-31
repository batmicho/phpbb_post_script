------- Simpe posting script for PHPBB forums using bash --------

Tested on PHPBB version: 3.2.0

An argument -h is provided which provides information on the script usage. Here is the -h output:

----

  PHPBB forum posting script.

  Usage: $0 [options]

  Open the script with a text editor and set your user and pass for both login sections http auth and forum auth,
    set your name in 'my_name' (which is the subject of the post) and the base URL of the forum in 'base_url'. Set the path to the file(file_path) which is the content you will post.

  Once configured with login details, file location and TL only run $0

 --list-tl
        List forum threads(TLs) to post to. The first number in the list is the number needed for variable "my_tl"
                                                                                                     Example: my_tl=7 .

 The script automatically sets the name and the current date in d/m/y format as a subject.
                                                                                                    M.D.
-----


