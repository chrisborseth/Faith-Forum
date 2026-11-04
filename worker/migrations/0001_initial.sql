CREATE TABLE IF NOT EXISTS threads (id TEXT PRIMARY KEY,subject TEXT NOT NULL,scripture TEXT NOT NULL DEFAULT '',created_at TEXT NOT NULL,updated_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS messages (id TEXT PRIMARY KEY,thread_id TEXT NOT NULL REFERENCES threads(id) ON DELETE CASCADE,author TEXT NOT NULL,body TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_thread_messages ON messages(thread_id,created_at);
