import React, { useEffect, useState, useRef } from 'react';
import { Badge, Progress } from '@mantine/core';
import { motion } from 'framer-motion';
import { NotifyData } from './Types';
import { config } from './Config';

interface PositionStyles {
  top?: string;
  bottom?: string;
  left?: string;
  right?: string;
}

interface NotificationProps {
  notifyData: NotifyData | null;
  visible: boolean;
}

const Notification: React.FC<NotificationProps> = ({ notifyData, visible }) => {
  const [isVisible, setIsVisible] = useState(visible);
  const [progress, setProgress] = useState(100);
  const textContainerRef = useRef<HTMLDivElement | null>(null);
  const [lineHeight, setLineHeight] = useState('30px');

  useEffect(() => {
    setIsVisible(visible);
  }, [visible]);

  useEffect(() => {
    if (notifyData) {
      const durationInMs = notifyData.Duration;
    
      const progressTimer = setInterval(() => {
        setProgress((prevProgress) => {
          if (prevProgress <= 0) {  clearInterval(progressTimer); return 0; }
          return prevProgress - 1; 
        });
      }, durationInMs / 100); 

      const removeTimer = setTimeout(() => {
        setIsVisible(false);
      }, durationInMs + 200);

      const cleanupTimer = setTimeout(() => {
        setIsVisible(false);
      }, durationInMs + 500);

      return () => {
        clearTimeout(removeTimer);
        clearTimeout(cleanupTimer);
        clearInterval(progressTimer); 
      };
    }
  }, [notifyData]);

  if (!notifyData) return null;

  useEffect(() => {
    if (textContainerRef.current) {
      const textHeight = textContainerRef.current.getBoundingClientRect().height;
      setLineHeight(`${textHeight * 0.8}px`);
    }
  }, [notifyData]);

  const { Title: title, Message: message, Type, Position, Effect } = notifyData;

  let positionStyles: PositionStyles = {};
  if (Position === 'top') positionStyles = { top: '20px', left: '45%' };
  else if (Position === 'bottom') positionStyles = { bottom: '20px', left: '45%' };
  else if (Position === 'top-left') positionStyles = { top: '20px', left: '20px' };
  else if (Position === 'top-right') positionStyles = { top: '20px', right: '20px' };
  else if (Position === 'bottom-left') positionStyles = { bottom: '20px', left: '20px' };
  else if (Position === 'bottom-right') positionStyles = { bottom: '20px', right: '20px' };

  let iconColor: string;
  if (Type === 'success') iconColor = 'teal';
  else if (Type === 'error') iconColor = 'red';
  else if (Type === 'warning') iconColor = 'yellow';  
  else iconColor = 'blue'; 

  return (
    <motion.div
      initial={{ opacity: 0 }} 
      animate={{ opacity: isVisible ? 1 : 0 }}
      exit={{ opacity: 0 }} 
      transition={{ duration: 0.5 }} 
      style={{
        position: 'absolute',
        zIndex: 1000,
        padding: '18px',
        backgroundColor: 'hsl(222.2 47.4% 11.2%)',
        color: 'white',
        borderRadius: '10px',
        fontFamily: 'Poppins, sans-serif',
        boxShadow: '0 4px 15px rgba(0, 0, 0, 0.2)',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'flex-start',
        ...positionStyles,
        minHeight: '40px',
      }}
    >
      <div style={{ position: 'absolute', top: '10px', right: '10px' }}>
        <Badge radius="md" color={iconColor} variant={config.badgeNotificationVariant}>
          {Type}
        </Badge>
      </div>
      {Effect === 'line' ? (
        <div style={{ display: 'flex', alignItems: 'center', color: iconColor }}>
          <div
            style={{
              width: '1.5px',
              height: lineHeight,
              borderRadius: '10px',
              backgroundColor: iconColor,
              marginRight: '14px',
            }}
          />
          <div ref={textContainerRef} style={{ color: '#e0e0e0', maxWidth: '300px', wordWrap: 'break-word' }}>
            <strong style={{ fontSize: '14px', fontWeight: '500', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
              {title}
            </strong>
            <p style={{ fontSize: '14px', color: '#b0b0b0', marginTop: '6px' }}>{message}</p>
          </div>
        </div>
      ) : (
        <>
          <div ref={textContainerRef} style={{ color: '#e0e0e0', maxWidth: '300px', wordWrap: 'break-word' }}>
            <strong style={{ fontSize: '14px', fontWeight: '500', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
              {title}
            </strong>
            <p style={{ fontSize: '14px', color: '#b0b0b0', marginTop: '6px' }}>{message}</p>
          </div>
          <div style={{ width: '100%' }}>
            <Progress value={progress} color={iconColor} size="xs" radius="xl" />
          </div>
        </>
      )}
    </motion.div>
  );
};

export default Notification;
