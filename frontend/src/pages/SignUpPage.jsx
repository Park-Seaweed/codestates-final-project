import React, { useState } from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

import { userApi } from '../api/userApi';

const SignUpPage = () => {
  const navigate = useNavigate();
  const [signUp, setSignUp] = useState({
    email: '',
    nickname: '',
    password: '',
  });

  const handleChange = (e) => {
    const { value, id } = e.target;
    setSignUp({
      ...signUp,
      [id]: value,
    });
  };

  console.log(signUp);

  const handleSignUp = async () => {
    try {
      const response = await userApi.signUp(signUp);
      console.log(response);
      navigate(`/signup/verify`);
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
            type='text'
            id='nickname'
            onChange={handleChange}
            placeholder='닉네임을 입력해주세요.'
          />
          <input
            type='password'
            id='password'
            onChange={handleChange}
            placeholder='비밀번호를 입력해주세요.'
          />
        </InputBox>
        <StButtonBox>
          <SignInButton onClick={handleSignUp}>SIGN UP</SignInButton>
        </StButtonBox>
      </SignInBox>
    </SignInContainer>
  );
};

export default SignUpPage;

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
  height: 110px;
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
    height: 33%;
    position: absolute;
    border-top: 1px solid #ffbc3f;
    border-bottom: 1px solid #ffbc3f;

    top: 33%;
    left: 0;
    right: 0;
  }

  input {
    width: 100%;
    height: 100%;
    outline: none;
    border: none;
    padding: 0 10px;
    z-index: 1;
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
