import React, { useState } from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

import { userApi } from '../api/userApi';

const SignInPage = () => {
  const navigate = useNavigate();
  const [signIn, setSignIn] = useState({ email: '', password: '' });

  const handleChange = (e) => {
    const { value, id } = e.target;
    setSignIn({
      ...signIn,
      [id]: value,
    });
  };

  console.log(signIn);

  const handleSignIn = async () => {
    try {
      const res = await userApi.signIn(signIn);
      console.log(res);
      localStorage.setItem('accessToken', res.data.accessToken);
      navigate(`/`);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <SignInContainer>
      <SignInBox>
        <InputBox>
          <input
            type='text'
            id='email'
            onChange={handleChange}
            placeholder='이메일을 입력해주세요.'
          />
          <input
            type='password'
            id='password'
            onChange={handleChange}
            placeholder='비밀번호를 입력해주세요.'
          />
        </InputBox>
        <StButtonBox>
          <SignInButton onClick={handleSignIn}>SIGN IN</SignInButton>
          <SignInButton
            onClick={() => {
              navigate(`/signup`);
            }}
          >
            SIGN UP
          </SignInButton>
        </StButtonBox>
      </SignInBox>
    </SignInContainer>
  );
};

export default SignInPage;

const SignInContainer = styled.div`
  width: 100%;
  height: 100vh;
  background-color: #ffbc3f;
  display: flex;
  justify-content: center;
  align-items: center;
`;

const SignInBox = styled.div`
  background-color: white;
  width: 300px;
  height: 200px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 20px;
  box-shadow: rgba(50, 50, 93, 0.25) 0px 2px 5px -1px,
    rgba(0, 0, 0, 0.3) 0px 1px 3px -1px;
`;

const InputBox = styled.div`
  width: 70%;
  height: 55px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 8px;
  padding: 5px 20px;
  align-items: center;
  position: relative;
  border: 1px solid #ffbc3f;
  border-radius: 10px;

  &:before {
    content: '';
    position: absolute;
    border-top: 1px solid #ffbc3f;
    top: 50%;
    left: 0;
    right: 0;
  }

  input {
    width: 100%;
    height: 100%;
    outline: none;
    border: none;
    padding: 0 10px;
  }
`;

const StButtonBox = styled.div`
  width: 85%;
  height: 30px;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 5px;
`;

const SignInButton = styled.button`
  background-color: #ffbc3f;
  width: 100%;
  height: 100%;
  border: none;
  border-radius: 10px;
  color: white;
`;
