import React from "react";
import { styled } from "@stitches/react";

interface FloatingActionButtonProps {
  onClick: React.MouseEventHandler<HTMLButtonElement>;
  icon: React.ReactNode;
}

const FabButton = styled("button", {
  position: "fixed",
  bottom: "20px",
  right: "20px",
  width: "56px",
  height: "56px",
  borderRadius: "50%",
  backgroundColor: "#6200ee",
  color: "white",
  boxShadow: "0px 2px 10px rgba(0, 0, 0, 0.2)",
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
  fontSize: "24px",
  cursor: "pointer",
  border: "none",

  "&:hover": {
    backgroundColor: "#3700b3",
  },

  "&:focus": {
    outline: "none",
    boxShadow: "0px 2px 10px rgba(0, 0, 0, 0.4)",
  },
});

const FloatingActionButton: React.FC<FloatingActionButtonProps> = ({
  onClick,
  icon,
}) => {
  return <FabButton onClick={onClick}>{icon}</FabButton>;
};

export default FloatingActionButton;
