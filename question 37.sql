CREATE TABLE module.playlists (
    playlist_id INT PRIMARY KEY,
    playlist_name VARCHAR(15)
);


CREATE TABLE module.playlist_tracks (
    playlist_id INT,
    track_id INT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES module.playlists(playlist_id)
);


CREATE TABLE module.playlist_plays (
    playlist_id INT,
    user_id VARCHAR(2),
    PRIMARY KEY (playlist_id, user_id),
    FOREIGN KEY (playlist_id) REFERENCES module.playlists(playlist_id)
);



INSERT INTO module.playlists (playlist_id, playlist_name) VALUES
(1, 'Rock Classics'),
(2, 'Pop Hits'),
(3, 'Jazz Vibes'),
(4, 'Indie Mix');

-- Insert sample data into playlist_tracks
INSERT INTO module.playlist_tracks (playlist_id, track_id) VALUES
(1, 101),
(1, 102),
(1, 103),
(2, 101),
(2, 104),
(2, 105),
(3, 106),
(3, 107),
(4, 101),
(4, 108);


INSERT INTO module.playlist_plays (playlist_id, user_id) VALUES
(1, 'U1'),
(1, 'U2'),
(2, 'U2'),
(2, 'U3'),
(3, 'U1'),
(3, 'U4'),
(4, 'U1');  



/*37)Suppose you are a data analyst working for Spotify (a music streaming service company) . 
Your company is interested in analyzing user engagement with playlists and wants to identify the most popular tracks 
among all the playlists. Write an SQL query to find the top 2 most popular tracks based on number of playlists they are part of. 
Your query should return the top 2 track ID along with total number of playlist they are part of , sorted by the same and track id in 
descending order , 
Please consider only those playlists which were played by at least 2 distinct users.*/

SELECT 
    pt.track_id,
    COUNT(DISTINCT pt.playlist_id) AS total_playlists
FROM module.playlist_tracks pt
JOIN (
    SELECT playlist_id
    FROM module.playlist_plays
    GROUP BY playlist_id
    HAVING COUNT(DISTINCT user_id) >= 2
) valid_playlists
    ON pt.playlist_id = valid_playlists.playlist_id
GROUP BY pt.track_id
ORDER BY total_playlists DESC, pt.track_id DESC
LIMIT 2;

