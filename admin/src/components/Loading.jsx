import { Box, CircularProgress } from '@mui/material'
import React from 'react'

export default function Loading() {
  return (
    <Box
    sx={{
      display: "flex",
      justifyContent: "center",
      paddingTop: "200px",
    }}
  >
    <CircularProgress />
  </Box>
  )
}
