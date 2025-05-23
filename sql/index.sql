CREATE TABLE form_field (
                            id UUID PRIMARY KEY,
                            label TEXT NOT NULL,
                            type TEXT NOT NULL CHECK (type IN ('text', 'select')),
                            position INTEGER NOT NULL UNIQUE
);

CREATE TABLE form_field_text (
                                 field_id UUID PRIMARY KEY REFERENCES form_field(id) ON DELETE CASCADE,
                                 min_length INTEGER CHECK (min_length >= 0),
                                 max_length INTEGER CHECK (max_length >= min_length)
);

CREATE TABLE form_field_select (
                                   field_id UUID PRIMARY KEY REFERENCES form_field(id) ON DELETE CASCADE
);

CREATE TABLE form_field_select_option (
                                   id SERIAL PRIMARY KEY,
                                   field_id UUID NOT NULL REFERENCES form_field_select(field_id) ON DELETE CASCADE,
                                   value TEXT NOT NULL,
                                   UNIQUE(field_id, value)
);

CREATE TABLE form_submission (
                                 id UUID PRIMARY KEY,
                                 submitted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

CREATE TABLE form_answer (
                             submission_id UUID REFERENCES form_submission(id) ON DELETE CASCADE,
                             field_id UUID REFERENCES form_field(id) ON DELETE CASCADE,
                             value TEXT NOT NULL,
                             PRIMARY KEY (submission_id, field_id)
);

-- Indexes for performance
CREATE INDEX idx_form_field_position ON form_field(position);
CREATE INDEX idx_form_answer_submission ON form_answer(submission_id);
