import React, { useEffect, useState } from 'react'
import { Button, OutlinedInput, TextField } from '@mui/material';
import { useLogin } from '../../hooks/useLogin';
import authService from '../../services/authService';
import './login.scss'
import { setLocalStorage } from '../../utils/localStorageHandle';
import { LOGIN_LS } from '../../constants/localStorage';
import { useLocation, useNavigate } from 'react-router-dom';
import { HOME_PATH } from '../../constants/path';
import { useAuth } from '../../hooks/useAuth';
import styled from '@emotion/styled';
import { sleep } from '../../utils/sleep';


export default function Login() {
  const [data, setData] = useState({})
  const [message, setMessage] = useState({type:"", content: ""})
  const navigate = useNavigate()
  const {user, setUser} = useAuth()

  useEffect(() => {
    document.title = 'Login - Admin';
  }, []);

  //Add props to styled component: https://viblo.asia/p/tuy-chinh-react-component-voi-styled-components-oOVlYR4v58W
  const MessageWrap = styled.div`
    color: ${props  => props.success ? "green" : "red"}`

  const login = async(data) => {
    try {
      const res = await authService.login(data)
      console.log(res);
      if(res)
        {
          setLocalStorage(LOGIN_LS, res.token)
          setLocalStorage('user', res.user)
          setUser(res.user)
          setMessage({type:"success", content: "Login Successfully"})
          navigate(HOME_PATH)
        }

      
    } catch (error) {
      setMessage({type:"error", content: "Email or password is invalid"})
    }
  }

  const onUsernameChange = (ev) => {
    data.username = ev.target.value
    setData(data)
  }
  const onPasswordChange = (ev) => {
    data.password = ev.target.value
    setData(data)
  }

  const onLogin = async() => {
    console.log(data);
    login(data)
    await sleep(500)
    navigate(HOME_PATH)
  }

  return (
    <div id='login-background'>
      <div className='login-form'>
      <div>Login</div>
      <div className='input-field'>
        <label className='input-label'>Username</label>
        <TextField size='small'  onChange={(ev)=>onUsernameChange(ev)} autoFocus/>
      </div>
      <div className='input-field'>
        <label className='input-label' >Password</label>
      <TextField type='password' size='small'  onChange={(ev)=>onPasswordChange(ev)}/>
      </div>
        <MessageWrap success={message.type === "success"}>{message?.content}</MessageWrap>
      <Button className='login-button' onClick={onLogin} > Log in </Button>
      </div>
    </div>
  )
}
