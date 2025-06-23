import { CssBaseline, Box, Container , Divider} from '@mui/material';
import * as React from 'react';
import ReactMarkdown from 'react-markdown';
interface AnswerCardProps {
  markdown: string;
  votes?: number;
  isAccepted?: boolean;
}

const AnswerCard = ({ markdown, votes = 0, isAccepted = false }: AnswerCardProps) => {
  return (
    <React.Fragment>
      <CssBaseline />
      <Container maxWidth="sm">
        <Box sx={{ paddingBottom: "30px",  overflowX: 'auto', whiteSpace: 'pre-wrap' }}> 
          <div className="flex-1 p-4 font-semibold">
            Votes: {votes}
          </div>
          {
            isAccepted 
            &&
            <div className="flex-1 p-4">
                 ✅ Accepted Answer
            </div>
          }
          <div className="prose mx-auto p-4">
            <ReactMarkdown>{markdown}</ReactMarkdown>
          </div>
        </Box>
        <Divider sx={{ my: 3 }} />
      </Container>
    </React.Fragment>

  );
};

export default AnswerCard;